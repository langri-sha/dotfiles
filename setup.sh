if [ -f "/etc/debian_version" ]; then
    sudo apt-get update
else
    echo "[ERROR] Sorry, your operating system isn't supported!"
fi
