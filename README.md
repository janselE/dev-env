# dev-env

A containerized development environment running Neovim, tmux, and common CLI tools inside Docker, with a transparent shell integration on the host.

## How it works

`setup.sh` runs on the host and:
1. Builds the Docker image (`dev:1.0.0`)
2. Adds shell functions and aliases to `~/.bashrc` so that `vim` and `tmux` transparently proxy into the running container
3. Sources `.custom_aliases` for short tmux aliases (`t`, `ta`, `tls`, `tn`)

Once the container is running, calling `vim` or `tmux` from the host automatically executes inside the container at your current working directory.

## Setup

```bash
./setup.sh
source ~/.bashrc
```

Then start the container from any directory that has a `docker-compose.yml`:

```bash
devstart
```

## Shell functions (added to `~/.bashrc`)

| Command | Behavior |
|---------|----------|
| `vim [file]` | Runs `nvim` inside the container (falls back to host `vim` if container is not running) |
| `tmux [args]` | Runs `tmux` inside the container (falls back to host `tmux` if container is not running) |
| `devstart` | Brings the container up via `docker compose` |

## Aliases (from `.custom_aliases`)

| Alias | Command |
|-------|---------|
| `t` | `tmux` (new session) |
| `ta` | `tmux a -t` (attach to session) |
| `tls` | `tmux ls` (list sessions) |
| `tn` | `tmux new -t` (new named session) |

## Container contents

- **Neovim** (built from source) with Lua config via [lazy.nvim](https://github.com/folke/lazy.nvim)
- **tmux** with TPM (tmux plugin manager)
- **CLI tools**: eza, bat, fzf, fd, ripgrep, zoxide, yazi, lazygit, lazydocker, btop, ncdu, jq, neofetch
- **Languages/runtimes**: Node.js, Python 3, Rust, tree-sitter
- **Docker-in-Docker** support via mounted socket

## Volume mounts

| Host path | Container path |
|-----------|----------------|
| `$HOME` | `$HOME` (same absolute path) |
| `/mnt` | `/mnt` |
| `$HOME/.gitconfig` | `/root/.gitconfig` (read-only) |
| `$HOME/.ssh` | `/root/.ssh` (read-only) |
| `./nvim` | `/root/.config/nvim` |
