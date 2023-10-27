if [ -d "/home/codespace" ] && [ -f "/etc/debian_version" ]; then
    sudo apt-get update

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    $HOME/.cargo/bin/cargo install \
        ripgrep \
        starship \
        tealdeer

    wget -O- https://apt.releases.hashicorp.com/gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
    sudo apt-get install terraform
    terraform -install-autocomplete
else
    echo "[ERROR] Sorry, your environment or operating system isn't supported!"
fi
