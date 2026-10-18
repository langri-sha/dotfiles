# shellcheck shell=bash
# Agent wrappers — inject secrets via 1Password CLI
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
      env_files+=("$HOME/workspace/environments/agents-gateway.env")
    else
      args+=("$arg")
    fi
  done
  if ((qwen && gateway)); then
    echo "claude: --qwen and --gateway both set ANTHROPIC_BASE_URL; pick one" >&2
    return 1
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
  if ((gateway)); then
    local url
    url=$(sed -n 's/^ANTHROPIC_BASE_URL=//p' "$HOME/workspace/environments/agents-gateway.env") || return 1
    if [[ -z "$url" ]]; then
      echo "codex: no ANTHROPIC_BASE_URL in agents-gateway.env" >&2
      return 1
    fi
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
