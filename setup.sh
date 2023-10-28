if [ -d "/home/codespace" ] && [ -f "/etc/debian_version" ]; then
    sudo apt-get update
    sudo apt-get install \
        cmake

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

    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
        sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update
    sudo apt-get install google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin
    gcloud init
else
    echo "[ERROR] Sorry, your environment or operating system isn't supported!"
    exit 1
fi
