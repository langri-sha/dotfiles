# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node

WORKDIR /workspace
COPY . .

RUN <<EOF
	useradd -m codespace
	usermod -aG sudo codespace
	echo "codespace ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/codespace
EOF

USER codespace

RUN <<EOF
	./setup.sh
EOF
