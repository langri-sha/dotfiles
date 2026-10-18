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

`claude` and `codex` run through the Aperture gateway on the existing login.

- `claude` loads `agents-gateway.env`, which sets `ANTHROPIC_BASE_URL` and
  nothing else.
- `codex` selects the `aperture` provider with `-c` overrides built from the
  same URL and leaves the model to the Codex config. A later `-c model=...`
  wins.

Opt out:

- `--direct` starts that agent without the gateway.
- `claude --qwen` starts without the gateway.
- `AGENTS_GATEWAY=0` turns the gateway off for every launch in that shell.
- `--gateway` is accepted and does nothing extra.

The gateway is probed with a one second `curl` first. If it is unreachable, the
agent starts direct and one line says so on stderr.

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
