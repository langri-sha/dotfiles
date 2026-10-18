#!/usr/bin/env bash
set -u

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

export HOME="$sandbox/home"
export PATH="$sandbox/bin:$PATH"
envs="$HOME/workspace/environments"
mkdir -p "$sandbox/bin" "$envs"

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
printf '%s %s\n' "$name" "$*"
if [[ $name == claude ]]; then
  printf 'path %s\n' "${PATH%%:*}"
fi
STUB

chmod +x "$sandbox/bin/op" "$sandbox/bin/agent"
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

lines() {
  local IFS=$'\n'
  printf '%s' "$*"
}

claude_path="path $HOME/.claude/bin"

expect "claude without flags loads agents and otel env files" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env --env-file=$envs/otel.env" \
    "claude --resume abc" "$claude_path")" \
  claude --resume abc

expect "claude --yolo becomes a bypassPermissions mode" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env --env-file=$envs/otel.env" \
    "claude --permission-mode bypassPermissions" "$claude_path")" \
  claude --yolo

expect "claude --qwen adds the qwen env file and is stripped" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env --env-file=$envs/otel.env --env-file=$envs/agents-qwen.env" \
    "claude --resume abc" "$claude_path")" \
  claude --qwen --resume abc

expect "codex without flags loads the agents env file" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" "codex exec hi")" \
  codex exec hi

expect "codex --yolo becomes the bypass flag" \
  "$(lines "op run --no-masking --env-file=$envs/agents.env" \
    "codex --dangerously-bypass-approvals-and-sandbox")" \
  codex --yolo

for name in opencode pi feynman hermes; do
  expect "$name loads the agents env file" \
    "$(lines "op run --no-masking --env-file=$envs/agents.env" "$name one two")" \
    "$name" one two
done

expect "letta loads the letta env file" \
  "$(lines "op run --no-masking --env-file=$envs/letta.env" "letta one two")" \
  letta one two

((failures == 0))
