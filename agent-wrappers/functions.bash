# shellcheck shell=bash
# Agent wrappers — inject secrets via 1Password CLI
_agents_gateway_url() {
  sed -n 's/^ANTHROPIC_BASE_URL=//p' "$HOME/workspace/environments/agents-gateway.env" 2>/dev/null
}

_agents_gateway_probe() {
  local url
  url=$(_agents_gateway_url)
  if [[ -z "$url" ]]; then
    echo "$1: no ANTHROPIC_BASE_URL in agents-gateway.env; starting direct" >&2
    return 1
  fi
  if ! curl -fsS -m 1 -o /dev/null "$url/" 2>/dev/null; then
    echo "$1: gateway unreachable at $url; starting direct" >&2
    return 1
  fi
  printf '%s\n' "$url"
}

claude() {
  local args=() env_files=("$HOME/workspace/environments/agents.env" "$HOME/workspace/environments/otel.env")
  local qwen=0 gateway=0
  for arg in "$@"; do
    if [[ "$arg" == "--yolo" ]]; then
      args+=(--permission-mode bypassPermissions)
    elif [[ "$arg" == "--qwen" ]]; then
      qwen=1
      env_files+=("$HOME/workspace/environments/agents-qwen.env")
    elif [[ "$arg" == "--gateway" ]]; then
      gateway=1
    else
      args+=("$arg")
    fi
  done
  if ((qwen && gateway)); then
    echo "claude: --qwen and --gateway both set ANTHROPIC_BASE_URL; pick one" >&2
    return 1
  fi
  if ((gateway)) && _agents_gateway_probe claude >/dev/null; then
    env_files+=("$HOME/workspace/environments/agents-gateway.env")
  fi
  local op_args=()
  for f in "${env_files[@]}"; do
    op_args+=(--env-file="$f")
  done
  PATH="$HOME/.claude/bin:$PATH" \
  op run --no-masking "${op_args[@]}" -- claude "${args[@]}"
}

opencode() {
  op run --no-masking --env-file="$HOME/workspace/environments/agents.env" -- opencode "$@"
}

codex() {
  local args=() gateway=0
  for arg in "$@"; do
    if [[ "$arg" == "--yolo" ]]; then
      args+=(--dangerously-bypass-approvals-and-sandbox)
    elif [[ "$arg" == "--gateway" ]]; then
      gateway=1
    else
      args+=("$arg")
    fi
  done
  local url
  if ((gateway)) && url=$(_agents_gateway_probe codex); then
    args=(
      -c 'model_provider="aperture"'
      -c "model_providers.aperture={name=\"Aperture\", base_url=\"$url/codex\", wire_api=\"responses\", requires_openai_auth=true}"
      "${args[@]}"
    )
  fi
  op run --no-masking --env-file="$HOME/workspace/environments/agents.env" -- codex "${args[@]}"
}

letta() {
  op run --no-masking --env-file="$HOME/workspace/environments/letta.env" -- letta "$@"
}

pi() {
  op run --no-masking --env-file="$HOME/workspace/environments/agents.env" -- pi "$@"
}

feynman() {
  op run --no-masking --env-file="$HOME/workspace/environments/agents.env" -- feynman "$@"
}

hermes() {
  op run --no-masking --env-file="$HOME/workspace/environments/agents.env" -- hermes "$@"
}
