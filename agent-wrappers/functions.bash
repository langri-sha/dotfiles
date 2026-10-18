# shellcheck shell=bash
# Agent wrappers — inject secrets via 1Password CLI
claude() {
  local args=() env_files=("$HOME/workspace/environments/agents.env" "$HOME/workspace/environments/otel.env")
  for arg in "$@"; do
    if [[ "$arg" == "--yolo" ]]; then
      args+=(--permission-mode bypassPermissions)
    elif [[ "$arg" == "--qwen" ]]; then
      env_files+=("$HOME/workspace/environments/agents-qwen.env")
    else
      args+=("$arg")
    fi
  done
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
  local args=()
  for arg in "$@"; do
    if [[ "$arg" == "--yolo" ]]; then
      args+=(--dangerously-bypass-approvals-and-sandbox)
    else
      args+=("$arg")
    fi
  done
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
