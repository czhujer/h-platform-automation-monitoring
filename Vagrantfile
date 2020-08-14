# -*- mode: ruby -*-
# vi: set ft=ruby :

# based on: https://github.com/czhujer/vagrant-kubernetes-sandbox/blob/master/Vagrantfile
#
# cheat sheet https://gist.github.com/czhujer/428adb509eeabba7c8f6a0f2dea916c1
#

Vagrant.require_version ">= 2.0.0"

Vagrant.configure('2') do |config|
  config.vm.define :"monitoring-stack" do |config_monitoring|
    config_monitoring.vm.box = 'centos/7'

    config_monitoring.vm.provider :libvirt do |v|
      v.memory = 1024
      v.cpus = 2
    end
    dir_monitoring = File.expand_path("..", __FILE__)
    puts "DIR_monitoring: #{dir_monitoring}"

    config_monitoring.vm.hostname = "monitoring-stack"
    #config_monitoring.vm.define "monitoring-stack"

    config_monitoring.vm.synced_folder dir_monitoring, '/vagrant', type: 'sshfs'

    # run ruby and puppet bootstrap
    config_monitoring.vm.provision :shell, :inline => "echo 'starting bootstrap ruby and puppet...'"
    config_monitoring.vm.provision :shell, path: File.join(dir_monitoring,'scripts/bootstrap_ruby.sh'), :privileged => true
    config_monitoring.vm.provision :shell, path: File.join(dir_monitoring,'scripts/bootstrap_puppet.sh'), :privileged => true

    # fix PKI
    config_monitoring.vm.provision :shell, :inline => "echo 'generate pki certs for webserver..'"
    config_monitoring.vm.provision :shell, path: File.join(dir_monitoring,'scripts/pki-make-dummy-cert.sh'), args: ["localhost"], :privileged => true

    #
    # run r10k and puppet apply
    #
    config_monitoring.vm.provision :shell, :inline => "echo 'starting r10k install .. and puppet apply...'"

    config_monitoring.vm.provision :shell, :inline => "cd /vagrant && cp configs-servers/h-prometheus-s1/Puppetfile /etc/puppet/Puppetfile", :privileged => true
    config_monitoring.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; cd /etc/puppet && r10k puppetfile install --force --puppetfile /etc/puppet/Puppetfile", :privileged => true

    #host_monitoring.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; facter", :privileged => true

    config_monitoring.vm.provision :shell, :inline => "cd /vagrant && cp configs-servers/h-prometheus-s1/*.pp /etc/puppet/manifests/", :privileged => true
    config_monitoring.vm.provision :shell, :inline => "source /opt/rh/rh-ruby25/enable; puppet apply --color=false --detailed-exitcodes /etc/puppet/manifests; retval=$?; if [[ $retval -eq 2 ]]; then exit 0; else exit $retval; fi;", :privileged => true

  end
end
