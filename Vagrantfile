Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "evabox"
  config.vm.define "evabox",
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provision :shell, privileged: false, path: "bootstrap.sh"
=begin
  config.vm.provision :shell, path: "startserver.sh", run: "always", privileged: false
=end
end
