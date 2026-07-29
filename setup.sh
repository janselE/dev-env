#!/usr/bin/env bash

# THESE ARE COMMANDS THAT ARE RAN ON HOST

# Build the docker image, matching the current user's UID/GID and the
# docker.sock group's GID so files/containers created inside come out
# owned correctly on the host instead of as root.
DOCKER_GID="$(getent group docker | cut -d: -f3)"
docker build -t dev:2.0.0 \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --build-arg USERNAME="$(whoami)" \
  --build-arg DOCKER_GID="${DOCKER_GID:-1001}" \
  .

# BASHRC="$HOME/.bashrc"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    BASHRC="$HOME/.bash_profile"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux (Ubuntu, Debian, etc.)
    BASHRC="$HOME/.bashrc"
else
    echo "Unknown OS type: $OSTYPE"
    BASHRC="$HOME/.bashrc"  # fallback
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOCK_START="# >>> docker dev-env aliases >>>"
BLOCK_END="# <<< docker dev-env aliases <<<"

# replace any existing block so re-running picks up changes to it
if grep -q "$BLOCK_START" "$BASHRC"; then
  sed -i "/^$BLOCK_START\$/,/^$BLOCK_END\$/d" "$BASHRC"
fi
cat << EOF >> "$BASHRC"
$BLOCK_START
TMUX_SESSIONS_FILE="$SCRIPT_DIR/tmux-sessions.conf"

devsessions() {
  local sessions_file="\$TMUX_SESSIONS_FILE"
  if [ ! -f "\$sessions_file" ]; then
    return 0
  fi
  local name dir cmd
  while IFS='|' read -r name dir cmd <&3 || [ -n "\$name" ]; do
    [[ -z "\$name" || "\$name" == \#* ]] && continue
    if docker exec -u "\$(whoami)" -e HOME=/root dev-env tmux has-session -t "\$name" 2>/dev/null; then
      continue
    fi
    local args=(-d -s "\$name")
    if [ -n "\$dir" ]; then
      dir="\$(eval echo "\$dir")"
      args+=(-c "\$dir")
    fi
    if [ -n "\$cmd" ]; then
      docker exec -u "\$(whoami)" -e HOME=/root dev-env tmux new-session "\${args[@]}" "\$cmd"
    else
      docker exec -u "\$(whoami)" -e HOME=/root dev-env tmux new-session "\${args[@]}"
    fi
  done 3< "\$sessions_file"
}

devstart() {
  local compose_file="$(pwd)/docker-compose.yml"
  if [ ! -f "\$compose_file" ]; then
    echo "Error: docker-compose.yml not found in current directory."
    return 1
  fi
  xhost +local: >/dev/null
  docker compose -f "\$compose_file" down
  docker compose -f "\$compose_file" up -d

  local retries=0
  until docker exec dev-env true >/dev/null 2>&1; do
    retries=\$((retries + 1))
    if [ "\$retries" -ge 20 ]; then
      echo "Warning: dev-env container did not become ready in time; skipping tmux session setup."
      return 0
    fi
    sleep 0.5
  done

  devsessions
}


vim() {

  if docker ps --format '{{.Names}}' | grep -q '^dev-env$'; then
    docker exec -it -u "\$(whoami)" -e HOME=/root -w "\$(pwd)" dev-env nvim "\$@"
  else
    command vim "\$@"
  fi
}


tmux() {
  if docker ps --format '{{.Names}}' | grep -q '^dev-env$'; then
    docker exec -it -u "\$(whoami)" -e HOME=/root -w "\$(pwd)" dev-env tmux -2 "\$@"
  else
    command tmux "\$@"
  fi
}
$BLOCK_END
EOF

ALIASES_LINE="source $SCRIPT_DIR/.custom_aliases"
if ! grep -q "\.custom_aliases" "$BASHRC"; then
  echo "$ALIASES_LINE" >> "$BASHRC"
  echo "unalias vim 2>/dev/null" >> "$BASHRC"
fi

sudo apt install neovim python3-neovim

source "$BASHRC"
