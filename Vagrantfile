# -*- mode: ruby -*-
# vi: set ft=ruby :

# based on: https://github.com/czhujer/vagrant-kubernetes-sandbox/blob/master/Vagrantfile
#
# cheat sheet https://gist.github.com/czhujer/428adb509eeabba7c8f6a0f2dea916c1
#

Vagrant.require_version ">= 2.0.0"

servers = {"vagrant" => {"h-prometheus-s1" => "vm"}}

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'

  config.vm.provider :libvirt do |v|
    v.memory = 1024
    v.cpus = 2
  end

  servers['vagrant'].each do |name, server_config|
    config.vm.define name do |host|
      config.vm.synced_folder '.', '/vagrant', type: 'sshfs'
      host.vm.hostname = name
    end

  end

  # run ruby and puppet bootstrap
  config.vm.provision :shell, :inline => "echo 'starting bootstrap ruby and puppet...'"
  config.vm.provision :shell, path: 'scripts/bootstrap_ruby.sh', :privileged => true
  config.vm.provision :shell, path: 'scripts/bootstrap_puppet.sh', :privileged => true

  #
  # run r10k and puppet apply
  #
  config.vm.provision :shell, :inline => "echo 'starting r10k install .. and puppet apply...'"

  servers['vagrant'].each do |name, server_config|
    config.vm.define name do |host|
      if name == "h-prometheus-s1"
        host.vm.provision :shell, :inline => "cd /vagrant && cp configs-servers/h-prometheus-s1/Puppetfile /etc/puppet/Puppetfile", :privileged => true
        host.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; cd /etc/puppet && r10k puppetfile install --force --puppetfile /etc/puppet/Puppetfile", :privileged => true

        #host.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; facter", :privileged => true

        host.vm.provision :shell, :inline => "cd /vagrant && cp configs-servers/h-prometheus-s1/*.pp /etc/puppet/manifests/", :privileged => true
        host.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; puppet apply --color=false --detailed-exitcodes /etc/puppet/manifests; retval=$?; if [[ $retval -eq 2 ]]; then exit 0; else exit $retval; fi;", :privileged => true
      else
      #host.vm.provision :shell, path: 'config/xxx', :privileged => true
      end
    end
  end

end
