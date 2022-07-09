# codepod
Self-hosted [code-server](https://coder.com/) instance with a few personal presets, for remote development.

![preview](https://user-images.githubusercontent.com/16148332/178113461-5c716d65-10e9-4c15-9acd-4a73f50701c7.png)

## Features
- Visual Studio Code in the browser, using **code-server** `4.4.0`
  - [**JetBrains Mono**](https://www.jetbrains.com/lp/mono/) as default editor font
  - [**Vitesse theme**](https://marketplace.visualstudio.com/items?itemName=antfu.theme-vitesse) (Dark Soft) as default editor theme
  - [**Helium Icon Theme**](https://marketplace.visualstudio.com/items?itemName=helgardrichard.helium-icon-theme) as default icon theme
  - [**Prettier**](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) extension, for code formatting
  - [**Svelte for VS Code**](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode) extension, for Svelte Intellisense
  - [**Docker for Visual Studio Code**](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension, for container management 
  - [**Vitest for VSCode**](https://marketplace.visualstudio.com/items?itemName=ZixuanChen.vitest-explorer) extension, for Vitest test discovery
- Node Version Manager (**nvm** `0.39.1`) with **node** `14.20.0`
- Fast, disk space efficient Node package manager (**pnpm** `7.5.0`)
- **Docker** `20.10.5` and **Docker Compose** `1.25.0`

## Install
Clone the hereby repo, add/edit settings at your convenience, and build the image.

```bash
git clone https://github.com/tommywalkie/codepod.git
docker build . --tag codepod:latest
```

## Usage

Run as a single container:

```bash
docker run -it --name "codepod" \
  -p 127.0.0.1:8080:8080 \
  -e PASSWORD="XXXX" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  codepod:latest
```

Run with Docker Compose:

```yaml
version: '3.1'

services:
  codepod:
    context: https://github.com/tommywalkie/codepod.git
    restart: unless-stopped
    privileged: true
    environment:
      PASSWORD: XXXX # Enable authentication
    ports:
      - '8080:8080'
    volumes:
      - ./my-settings:/home/coder/.local/share/code-server # You may want to mount your editor settings folder
      - /var/run/docker.sock:/var/run/docker.sock # Interact with Docker from inside the container
```
