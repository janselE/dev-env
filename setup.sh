#!/bin/sh

# THESE ARE COMMANDS THAT ARE RAN ON HOST

# Build the docker image
docker build -t dev:1.0.0 .

#!/bin/sh

BASHRC="$HOME/.bashrc"
BLOCK_START="# >>> docker dev-env aliases >>>"
BLOCK_END="# <<< docker dev-env aliases <<<"

# adds this section only if it has not been added yet
if ! grep -q "$BLOCK_START" "$BASHRC"; then
  cat << EOF >> "$BASHRC"
$BLOCK_START
devstart() {
  local compose_file="$(pwd)/docker-compose.yml"
  if [ ! -f "\$compose_file" ]; then
    echo "Error: docker-compose.yml not found in current directory."
    return 1
  fi
  docker compose -f "\$compose_file" down
  docker compose -f "\$compose_file" up -d
}


vim() {

  if docker ps --format '{{.Names}}' | grep -q '^dev-env$'; then
    docker exec -it -w "\$(pwd)" dev-env nvim "\$@"
  else
    command vim "\$@"
  fi
}


tmux() {
  if docker ps --format '{{.Names}}' | grep -q '^dev-env$'; then
    docker exec -it -w "\$(pwd)" dev-env tmux -2 "\$@"
  else
    command tmux "\$@"
  fi
}
$BLOCK_END
EOF
fi

sudo apt install neovim python3-neovim

source $HOME/.bashrc
