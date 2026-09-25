# Sandbox

A small Debian image with everything the exercises need: OpenSSL 3.5,
Python with `cryptography`, `xxd`, `curl`, SSH client, `tcpdump` and friends.

| How | Command |
|-----|---------|
| Codespaces / VS Code | uses [../.devcontainer/devcontainer.json](../.devcontainer/devcontainer.json) automatically |
| Make | `make shell` from the repo root |
| Docker | `docker build -t itc-sandbox sandbox && docker run --rm -it -v "$PWD":/workspace itc-sandbox` |

The repo is mounted at `/workspace` (in Codespaces: `/workspaces/<repo>`), and
`$COURSES` points there. Exercises write to `~/lab/<course>` inside the
container. With `--rm`, that folder is gone when you exit, which is fine
because everything in it is throwaway.

When a course needs more tools (for example `telnetd` and `sshd` for a
multi-host lab), add them here or give that course its own
`lab/compose.yaml` that builds on this image.
