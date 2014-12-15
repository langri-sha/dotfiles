VAGRANTFILE_API_VERSION = "2"

repository = "/home/vagrant/dotfiles-local"
script = <<-END
set -e

if [ ! -f /etc/configured ]; then
  sudo apt-get update
  sudo apt-get install -y ansible
  sudo touch /etc/configured
fi

command=( \
  ansible-playbook \
    --inventory-file=#{repository}/ansible/hosts
    --connection=local --verbose \
    #{repository}/ansible/playbook.yml \
)
sudo su vagrant --command="${command[*]}"
END

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder ".", repository
  config.vm.provision "shell", inline: script

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
