#!/bin/sh

# THESE ARE COMMANDS THAT ARE RAN ON HOST

# Build the docker image
docker build -t dev:1.0.0 .


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

BLOCK_START="# >>> docker dev-env aliases >>>"
BLOCK_END="# <<< docker dev-env aliases <<<"

# adds this section only if it has not been added yet
if ! grep -q "$BLOCK_START" "$BASHRC"; then
  cat << EOF >> "$BASHRC"
$BLOCK_START
alias dstart='
  # Remove existing container if it exists (ensures no outdated container remains)
  if docker ps -a --format "{{.Names}}" | grep -q "^dev-env$"; then
    docker rm -f dev-env >/dev/null 2>&1
  fi

  # Start a new container
  docker run -dit \
    --name dev-env \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v \$HOME:\$HOME \
    -v /mnt:/mnt \
    -v /tmp/nvim-socket:/tmp/nvim-socket \
    -w "\$(pwd)" \
    dev:1.0.0 bash

  # Attach to the container
  # docker exec -it dev-env bash
'


vim() {

    docker exec -it -w "\$(pwd)" dev-env nvim "\$@"
}


nvim() {
    docker exec -it -w "\$(pwd)" dev-env nvim "\$@"
}

tmux() {
    docker exec -it -w "\$(pwd)" dev-env tmux -2 "\$@"
}
$BLOCK_END
EOF
fi

sudo apt install neovim python3-neovim

source "$BASHRC" 
