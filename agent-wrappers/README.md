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

## Gateway

`--gateway` routes an agent through the Aperture gateway on its existing
login. Without the flag nothing changes.

- `claude --gateway` adds `agents-gateway.env`, which sets
  `ANTHROPIC_BASE_URL` and nothing else. It cannot be combined with `--qwen`.
- `codex --gateway` selects the `aperture` provider with `-c` overrides, built
  from the same URL, and leaves the model to the Codex config. A later
  `-c model=...` wins.

The gateway is probed with a one second `curl` first. If it is unreachable, the
agent starts direct and one line says so on stderr.

The flag is not remembered: pass it again when resuming a session, for example
`claude --gateway --resume <id>`, or the session goes direct.

## Tests

```sh
shellcheck agent-wrappers/*.bash
bash agent-wrappers/test.bash
```

## Sourcing

Add this to `~/.bashrc`:

```sh
source "$HOME/workspace/dotfiles/main/agent-wrappers/functions.bash"
```
