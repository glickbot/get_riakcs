# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'
FileUtils::mkdir_p '.vagrant/tmp/system/hosts.d'

VAGRANTFILE_API_VERSION = "2"
NODES = 3
BASEIP = 5
IP_PRE = "10.42.0."
DOMAIN = "localdomain"

opts = []

Dir.glob('./.vagrant/tmp/system/hosts.d/*.host').each { |f| File.delete(f) }

(1..NODES).each do |n|
    opts[n] = { :name => "node#{n}", :hostname => "node#{n}.#{DOMAIN}", :ip => "#{IP_PRE}#{BASEIP + n.to_i}" }
    File.open("./.vagrant/tmp/system/hosts.d/03-#{opts[n][:name]}.hosts", 'w') do |hostfile|
      hostfile.puts "#{opts[n][:ip]}       #{opts[n][:name]} #{opts[n][:hostname]} "
    end
end


Vagrant.configure(2) do |config|

  config.vm.box = "Chef-CentOS-6.5"

  config.vm.define :builder, autostart: false do |build|
    build.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release
      yum install -y python-virtualenv gcc git
      mkdir -p /vagrant/build/centos6/get_riakcs
      cd /vagrant/build/centos6/get_riakcs
      virtualenv sandbox
      virtualenv sandbox --relocatable
      source sandbox/bin/activate
      easy_install ansible
      rsync -avp /vagrant/deploy/ ./
      cd /vagrant
      make centos6
    SHELL
  end
  (1..NODES).each do |n|

    name = opts[n][:name]
    hostname = opts[n][:hostname]
    ip   = opts[n][:ip]
    config.vm.define name do |config|
      config.vm.network :private_network, ip: "#{ip}"
      config.vm.network "forwarded_port", guest: 80, host: "800#{n}".to_i
      config.vm.network "forwarded_port", guest: 8098, host: "809#{n}".to_i
      config.vm.network "forwarded_port", guest: 8080, host: "808#{n}".to_i
      config.vm.provision "shell", inline: <<SHELL
        yum install -y perl
        perl -pi -e "s/HOSTNAME=.*/HOSTNAME=#{hostname}/" /etc/sysconfig/network
        perl -pi -e "s/(.*localhost.*)/\\1 #{name} #{hostname}/" /etc/hosts
        hostname "#{hostname}"
        cat /vagrant/.vagrant/tmp/system/hosts.d/*.hosts >> /etc/hosts
SHELL
      config.vm.provision "shell", inline: <<-SHELL
        yum install -y screen
        cd /opt
        tar -xzf /vagrant/build/centos6/get_riakcs-v0.01-centos6.tar.gz
        cd get_riakcs
        screen -d -m ./install.sh
      SHELL
    end
  end
end
