# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node

WORKDIR /workspace
COPY . .

RUN <<EOF
	useradd -m codespace
EOF
