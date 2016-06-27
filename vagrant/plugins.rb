def install_plugin(plugin)
  install_plugins [plugin]
end

def install_plugins(required)
  missing = required.reject { |plugin| Vagrant.has_plugin? plugin }
  if not missing.empty? 
    missing.each do |plugin|
      if not system "vagrant plugin install #{plugin}"
        abort "Couldn't install the required plugin #{plugin}, aborting."
      end
    end
    exec "vagrant #{ARGV.join(' ')}"
  end
end
