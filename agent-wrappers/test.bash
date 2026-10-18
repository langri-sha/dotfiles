#!/usr/bin/env bash
set -u

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

export HOME="$sandbox/home"
export PATH="$sandbox/bin:$PATH"
envs="$HOME/workspace/environments"
mkdir -p "$sandbox/bin" "$envs"
printf 'ANTHROPIC_BASE_URL=http://gateway.test\n' > "$envs/agents-gateway.env"

cat > "$sandbox/bin/op" <<'STUB'
#!/usr/bin/env bash
pre=()
while [[ $# -gt 0 && $1 != -- ]]; do
  pre+=("$1")
  shift
done
shift
printf 'op %s\n' "${pre[*]}"
exec "$@"
STUB

cat > "$sandbox/bin/agent" <<'STUB'
#!/usr/bin/env bash
name=${0##*/}
printf '%s\n' "$name${*:+ $*}"
if [[ $name == claude ]]; then
  printf 'path %s\n' "${PATH%%:*}"
fi
STUB

cat > "$sandbox/bin/curl" <<'STUB'
#!/usr/bin/env bash
printf 'curl %s\n' "$*" >> "$HOME/probes"
((${PROBE_FAIL:-0} == 0))
STUB

chmod +x "$sandbox/bin/op" "$sandbox/bin/agent" "$sandbox/bin/curl"
for name in claude codex opencode letta pi feynman hermes; do
  ln -s agent "$sandbox/bin/$name"
done

failures=0

run() {
  bash -c 'source "$1"; shift; "$@"' _ "$here/functions.bash" "$@" 2>&1
}

expect() {
  local name=$1 expected=$2
  shift 2
  local actual
  actual=$(run "$@")
  if [[ $actual == "$expected" ]]; then
    printf 'ok   %s\n' "$name"
  else
    printf 'FAIL %s\n--- expected\n%s\n--- actual\n%s\n' "$name" "$expected" "$actual"
    failures=$((failures + 1))
  fi
}

expect_file() {
  local name=$1 expected=$2 file=$3
  local actual=
  [[ -f $file ]] && actual=$(<"$file")
  if [[ $actual == "$expected" ]]; then
    printf 'ok   %s\n' "$name"
  else
    printf 'FAIL %s\n--- expected\n%s\n--- actual\n%s\n' "$name" "$expected" "$actual"
    failures=$((failures + 1))
  fi
}

lines() {
  local IFS=$'\n'
  printf '%s' "$*"
}

claude_path="path $HOME/.claude/bin"
claude_op="op run --no-masking --env-file=$envs/agents.env --env-file=$envs/otel.env"
claude_gateway_op="$claude_op --env-file=$envs/agents-gateway.env"
claude_qwen_op="$claude_op --env-file=$envs/agents-qwen.env"
unreachable="claude: gateway unreachable at http://gateway.test; starting direct"

expect "claude defaults to the gateway env file" \
  "$(lines "$claude_gateway_op" "claude --resume abc" "$claude_path")" \
  claude --resume abc

expect "claude --yolo becomes a bypassPermissions mode and keeps the gateway" \
  "$(lines "$claude_gateway_op" "claude --permission-mode bypassPermissions" "$claude_path")" \
  claude --yolo

expect "claude --direct skips the gateway env file and is stripped" \
  "$(lines "$claude_op" "claude --resume abc" "$claude_path")" \
  claude --direct --resume abc

expect "claude --yolo --direct keeps the bypass flag without the gateway" \
  "$(lines "$claude_op" "claude --permission-mode bypassPermissions" "$claude_path")" \
  claude --yolo --direct

expect "claude --qwen adds the qwen env file without the gateway" \
  "$(lines "$claude_qwen_op" "claude --resume abc" "$claude_path")" \
  claude --qwen --resume abc

expect "claude --yolo --qwen keeps the bypass flag without the gateway" \
  "$(lines "$claude_qwen_op" "claude --permission-mode bypassPermissions" "$claude_path")" \
  claude --yolo --qwen

expect "claude --qwen --direct behaves as --qwen" \
  "$(lines "$claude_qwen_op" "claude" "$claude_path")" \
  claude --qwen --direct

expect "claude --gateway is accepted, stripped and changes nothing" \
  "$(lines "$claude_gateway_op" "claude --resume abc" "$claude_path")" \
  claude --gateway --resume abc

expect "claude --gateway --direct goes direct" \
  "$(lines "$claude_op" "claude" "$claude_path")" \
  claude --gateway --direct

expect "claude --qwen --gateway goes to qwen without the gateway" \
  "$(lines "$claude_qwen_op" "claude" "$claude_path")" \
  claude --qwen --gateway

AGENTS_GATEWAY=0 expect "claude with AGENTS_GATEWAY=0 goes direct" \
  "$(lines "$claude_op" "claude --resume abc" "$claude_path")" \
  claude --resume abc

AGENTS_GATEWAY=0 expect "claude --gateway with AGENTS_GATEWAY=0 goes direct" \
  "$(lines "$claude_op" "claude" "$claude_path")" \
  claude --gateway

AGENTS_GATEWAY=1 expect "claude with AGENTS_GATEWAY=1 uses the gateway" \
  "$(lines "$claude_gateway_op" "claude" "$claude_path")" \
  claude

PROBE_FAIL=1 expect "claude falls back to direct when the gateway probe fails" \
  "$(lines "$unreachable" "$claude_op" "claude --resume abc" "$claude_path")" \
  claude --resume abc

PROBE_FAIL=1 expect "claude --yolo falls back to direct when the gateway probe fails" \
  "$(lines "$unreachable" "$claude_op" "claude --permission-mode bypassPermissions" "$claude_path")" \
  claude --yolo

PROBE_FAIL=1 expect "claude --qwen does not probe the gateway" \
  "$(lines "$claude_qwen_op" "claude" "$claude_path")" \
  claude --qwen

PROBE_FAIL=1 expect "claude --direct does not probe the gateway" \
  "$(lines "$claude_op" "claude" "$claude_path")" \
  claude --direct

rm -f "$HOME/probes"
run claude >/dev/null
expect_file "claude probes the gateway root with a one second limit" \
  "curl -fsS -m 1 -o /dev/null http://gateway.test/" "$HOME/probes"

rm -f "$HOME/probes"
run claude --direct >/dev/null
AGENTS_GATEWAY=0 run claude >/dev/null
run claude --qwen >/dev/null
expect_file "claude does not probe when the gateway is off" "" "$HOME/probes"

mv "$envs/agents-gateway.env" "$envs/agents-gateway.env.away"
expect "claude falls back to direct without a gateway env file" \
  "$(lines "claude: no ANTHROPIC_BASE_URL in agents-gateway.env; starting direct" \
    "$claude_op" "claude" "$claude_path")" \
  claude
mv "$envs/agents-gateway.env.away" "$envs/agents-gateway.env"

expect "codex without flags loads the agents env file" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" "codex exec hi")" \
  codex exec hi

expect "codex --yolo becomes the bypass flag" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" \
    "codex --dangerously-bypass-approvals-and-sandbox")" \
  codex --yolo

codex_gateway_flags="-c model_provider=\"aperture\" -c model_providers.aperture={name=\"Aperture\", base_url=\"http://gateway.test/codex\", wire_api=\"responses\", requires_openai_auth=true}"

expect "codex --gateway selects the aperture provider and is stripped" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" \
    "codex $codex_gateway_flags exec hi")" \
  codex --gateway exec hi

expect "codex --yolo --gateway keeps both effects" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" \
    "codex $codex_gateway_flags --dangerously-bypass-approvals-and-sandbox")" \
  codex --yolo --gateway

expect "codex --gateway leaves later model overrides in place" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" \
    "codex $codex_gateway_flags -c model=\"gpt-5.6-terra\"")" \
  codex --gateway -c 'model="gpt-5.6-terra"'

PROBE_FAIL=1 expect "codex --gateway falls back to direct when the gateway probe fails" \
  "$(lines "codex: gateway unreachable at http://gateway.test; starting direct" \
    "op run --no-masking --env-file=$envs/agents.env" "codex exec hi")" \
  codex --gateway exec hi

rm -f "$HOME/probes"
run codex --gateway >/dev/null
expect_file "codex --gateway probes the gateway root with a one second limit" \
  "curl -fsS -m 1 -o /dev/null http://gateway.test/" "$HOME/probes"

rm -f "$HOME/probes"
run codex >/dev/null
expect_file "codex without flags does not probe the gateway" "" "$HOME/probes"

for name in opencode pi feynman hermes; do
  expect "$name loads the agents env file" \
    "$(lines "op run --no-masking --env-file=$envs/agents.env" "$name one two")" \
    "$name" one two
done

expect "letta loads the letta env file" \
  "$(lines "op run --no-masking --env-file=$envs/letta.env" "letta one two")" \
  letta one two

((failures == 0))
