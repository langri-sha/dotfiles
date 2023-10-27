if [ -f "/etc/debian_version" ]; then
    sudo apt-get update

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    $HOME/.cargo/bin/cargo install \
        ripgrep \
        starship
else
    echo "[ERROR] Sorry, your operating system isn't supported!"
fi
