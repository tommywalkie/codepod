FROM codercom/code-server:4.4.0

# Install Docker and a few packages
RUN sudo apt update
RUN sudo apt install -y --no-install-recommends build-essential \
    git \
    curl \
    jq \
    libarchive-tools \
    nano \
    docker.io \
    docker-compose \
    wget \
    unzip

# Make sure the default user 'coder' has access to Docker
USER root
RUN sudo usermod -aG docker coder
USER coder

# Install Visual Studio Code extensions
RUN code-server --install-extension svelte.svelte-vscode \
    code-server --install-extension esbenp.prettier-vscode \
    code-server --install-extension csstools.postcss \
    code-server --install-extension MS-CEINTL.vscode-language-pack-fr \
    code-server --install-extension jpoissonnier.vscode-styled-components \
    code-server --install-extension ZixuanChen.vitest-explorer \
    code-server --install-extension bierner.color-info \
    code-server --install-extension dbaeumer.vscode-eslint \
    code-server --install-extension editorconfig.editorconfig \
    code-server --install-extension ms-azuretools.vscode-docker \
    code-server --install-extension mikestead.dotenv \
    code-server --install-extension bradlc.vscode-tailwindcss

# Install manually some extensions which weren't available/up-to-date in Open-VSX
COPY ./extensions ./extensions
RUN code-server --install-extension ./extensions/antfu.theme-vitesse-0.5.0.vsix \
    code-server --install-extension ./extensions/helgardrichard.helium-icon-theme-1.0.0.vsix

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder

SHELL ["/bin/bash", "-c"]

# Install Node Version Manager
RUN set +ex; \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash; \
    export NVM_DIR="$HOME/.nvm"; \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"; \
    nvm install 14

# Install PNPM
RUN curl -fsSL https://get.pnpm.io/install.sh | bash

# Copy settings
RUN mkdir -p /home/coder/.local/share/code-server/User
COPY ./settings.json /home/coder/.local/share/code-server/User/settings.json

# Add JetBrains Mono font
WORKDIR /usr/lib/code-server
RUN find . -name workbench.html | sudo xargs sed -i "s%</head>%<style>@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono\&display=swap');</style></head>%g"

WORKDIR /home/coder

ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "--disable-telemetry", "."]