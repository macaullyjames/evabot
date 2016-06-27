require_relative 'vagrant/plugins'
require_relative 'vagrant/os'

Vagrant.configure(2) do |config|
  install_plugin 'vagrant-triggers'

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "evabox"
  config.vm.define "evabox",
  config.vm.box_check_update = false
  config.vm.synced_folder '.', '/evabot'
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provision :shell, privileged: false, path: "vagrant/bootstrap.sh"
  config.vm.provision :shell, privileged: false, path: "vagrant/up.sh", run: "always"

  config.trigger.after :up do
    if OS.mac?
      system "open http://localhost:3000"
    elsif OS.windows?
      system "start http://localhost:3000"
    end
  end
end
