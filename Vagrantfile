VAGRANTFILE_API_VERSION = "2"

$SCRIPT = <<-END
set -e

if [ ! -f /etc/configured ]; then
  sudo apt-get update
  sudo apt-get install -y ansible git
  sudo touch /etc/configured
fi

cat <<-EOF > /etc/ansible/hosts
[dev]
localhost ansible_connection=local
EOF

command=( \
  ansible-playbook \
    --connection=local --verbose \
    /vagrant/playbook.yml \
)
sudo su vagrant --command="${command[*]}"
END

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"

  config.vm.synced_folder ".", "/home/vagrant/dotfiles-local"
  config.vm.provision "shell", inline: $SCRIPT

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
end
