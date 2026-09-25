🇬🇧 English · 🇳🇱 [Nederlands](joining.nl.md)

# Joining a course

Every course is 30–50 minutes: a short talk, then exercises in one of two
tracks, then a debrief together. You choose your track at the start of the
session.

| | 🗣 Explainer | 🛠 Builder |
|---|---|---|
| **You are…** | someone who explains to clients, partners or colleagues *what* is needed and *why* | someone who configures, builds or troubleshoots it yourself |
| **Exercises** | scenario cards, in pairs, on paper | commands in a terminal |
| **You need** | nothing, just bring a pen | a laptop with the sandbox (below) |

Not sure? Come as an explainer. You can always follow the builders' exercises
on the big screen.

## 🗣 Explainers: nothing to prepare

The facilitator brings printed scenario cards and a one-page handout. If you
want to read ahead, every course page has a link to both.

## 🛠 Builders: get the sandbox ready *before* the session

The **sandbox** is a small Linux environment with all the tools installed, so
everyone has the same versions and nobody has to install anything on their own
laptop. Pick **one** of these options. Allow 10 minutes; the first start takes
a few minutes while it downloads.

### Option A · In your browser (GitHub Codespaces)

Easiest: nothing to install. You need a GitHub account with access to the course repository.

1. Open the course repository on GitHub (the link is in your invite).
2. Click **Code → Codespaces → Create codespace on main**.
3. Wait until VS Code opens in your browser with a terminal at the bottom.

When the course is over, delete the codespace (**Code → Codespaces → ⋯ → Delete**),
so it doesn't use up your free hours.

### Option B · VS Code + Docker Desktop

Works offline once it's set up.

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/),
   [VS Code](https://code.visualstudio.com/) and the VS Code extension
   **Dev Containers**.
2. Clone the course repository. On Windows, clone it **inside WSL** (for example
   in `~/projects`) and open it from there with `code .`.
3. VS Code asks whether to **Reopen in Container**. Click it, or run
   *Dev Containers: Reopen in Container* from the command palette (`F1`).
4. Open a terminal (**Terminal → New Terminal**). The prompt shows `student@…`.

### Option C · Plain Docker, no VS Code

From the cloned repository:

```shell
docker build -t itc-sandbox sandbox
docker run --rm -it -v "$PWD":/workspace itc-sandbox
```

In Windows PowerShell, use `${PWD}` instead of `"$PWD"`.

### Option D · Your own Linux or WSL shell

Only if you're comfortable with that. You need OpenSSL 3, Python with
`cryptography`, `xxd` and `file` (on Debian or Ubuntu:
`sudo apt install openssl python3-cryptography xxd file`). Then, in the repository:

```shell
export COURSES=$(pwd)
```

The macOS built-in `openssl` is LibreSSL and behaves differently: use option A, B or C instead.

## ✅ Am I ready?

In the sandbox terminal, run:

```shell
bash "$COURSES/tools/ready.sh"
```

```text
Checking your course environment…
  ✅ OpenSSL 3.5.7 9 Jun 2026 (Library: OpenSSL 3.5.7 9 Jun 2026)
  ✅ Python with the cryptography library
  ✅ xxd
  ✅ file
  ✅ COURSES points to the course files (/workspace)

🎉 You're ready. See you at the course!
```

Any ❌ comes with a hint. Didn't manage in time? Come anyway: pair up with
someone, or follow along on the big screen.

## During the session

- Open the **course page** (for example `courses/01-crypto-basics/README.md`).
  It links to the worksheets in the order you need them.
- Everything you create goes in `~/lab/<course number>`, never in the
  repository. It's all throwaway.
- Each course has a self-check that tells you what you've done and what's left.
  The course page shows the command.

## If something doesn't work

| Problem | Try this |
|---------|----------|
| No **Codespaces** option on the Code button | Codespaces may not be enabled for your account or organisation. Use option B or C. |
| `docker: command not found` in WSL | Docker Desktop → *Settings → Resources → WSL integration* → enable your distro, then open a new terminal. |
| `permission denied … docker.sock` | Your user isn't in the `docker` group yet: `sudo usermod -aG docker $USER`, then close and reopen VS Code or WSL (`wsl --shutdown`). |
| Building the sandbox fails while downloading | Try another network. Company VPNs and proxies sometimes block Docker downloads. |
| The dev container starts, but the terminal says `root@…` or there's no `$COURSES` | Rebuild: *Dev Containers: Rebuild Container* from the command palette. |
| Still stuck | Tell the facilitator before the session starts, or just come: you can pair up. |
