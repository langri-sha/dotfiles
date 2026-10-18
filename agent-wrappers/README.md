# Agent wrappers

Shell functions that start coding agents with their secrets injected by
[`op run`](https://developer.1password.com/docs/cli/reference/commands/run/),
reading the env files in `~/workspace/environments`.

| Function   | Env files                      |
| ---------- | ------------------------------ |
| `claude`   | `agents.env`, `otel.env`       |
| `codex`    | `agents.env`                   |
| `opencode` | `agents.env`                   |
| `pi`       | `agents.env`                   |
| `feynman`  | `agents.env`                   |
| `hermes`   | `agents.env`                   |
| `letta`    | `letta.env`                    |

`claude --yolo` and `codex --yolo` map to each agent's bypass flag.
`claude --qwen` adds `agents-qwen.env`.

## Sourcing

Add this to `~/.bashrc`:

```sh
source "$HOME/workspace/dotfiles/main/agent-wrappers/functions.bash"
```
