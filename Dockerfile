FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV BAT_THEME=Nord
ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PATH="/root/.local/bin:${PATH}"

# Update system and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    tar \
    neofetch \
    tmux \
    python3-pip \
    luarocks \
    bat \
    fzf \
    fd-find \
    jq \
    ncdu \
    tldr \
    gpg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (latest current version)
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Install eza from official repo
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list && \
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && \
    apt-get update && apt-get install -y eza && \
    rm -rf /var/lib/apt/lists/*

# set up the Docker apt repository
COPY install_docker.sh /tmp/install.sh

# Make it executable and run it
RUN chmod +x /tmp/install.sh && /tmp/install.sh

# Install docker
RUN apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin


# Install Neovim (latest from GitHub)
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz

# Copy Neovim config
COPY nvim /root/.config/nvim
# RUN mkdir -p /root/.config && ln -s /workspace/nvim /root/.config/nvim

# Copy tmux config
COPY .tmux.conf /root/.tmux.conf

# Install lazygit (inside container only)
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/^v//') && \
    mkdir -p /tmp/lazygit && \
    curl -Lo /tmp/lazygit/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar -C /tmp/lazygit -xf /tmp/lazygit/lazygit.tar.gz lazygit && \
    install /tmp/lazygit/lazygit /usr/local/bin/ && \
    rm -rf /tmp/lazygit

# Install bat (Ubuntu calls it batcat)
RUN ln -s /usr/bin/batcat /usr/local/bin/bat

# Install tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Python tools
RUN pip install pylint

# Clone fzf-git.sh repo
RUN git clone https://github.com/junegunn/fzf-git.sh.git /root/fzf-git

# Copy custom bashrc
COPY .custom_bashrc /root/.custom_bashrc

# Source it from bashrc
RUN echo "source /root/.custom_bashrc" >> /root/.bashrc
RUN apt-get update && apt-get install -y \
    python3.10-venv

# For icons to work on tmux
RUN apt update && apt install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install zeoxide
RUN curl -fsSL https://apt.cli.rs/pubkey.asc | tee -a /usr/share/keyrings/rust-tools.asc
RUN curl -fsSL https://apt.cli.rs/rust-tools.list | tee /etc/apt/sources.list.d/rust-tools.list
RUN apt update
RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

