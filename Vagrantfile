Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "evabox"
  config.vm.define "evabox",
  config.vm.box_check_update = false
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/evabot'
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provision :shell, privileged: false, path: "bootstrap.sh"
  config.vm.provision :shell, privileged: false, run: "always",
      inline: "cd /evabot/rails && rails server --daemon -b 0.0.0.0"
end
