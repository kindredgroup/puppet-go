Vagrant.configure("2") do |config|

  # shared bootstrap
  setup = <<SETUP
iptables --flush
puppet apply -e "package { 'rubygems': ensure => installed}"
puppet apply -e "package { 'librarian-puppet': ensure => '1.4.0', provider => 'gem' }"
puppet apply -e "package { 'java-1.7.0-openjdk': ensure => installed }"
cd /vagrant
librarian-puppet install --path /etc/puppet/modules
rm -rf /etc/puppet/modules/go
cp -r /vagrant /etc/puppet/modules/go
SETUP

  # server bootstrap
  server = <<SERVER
#{setup}
puppet apply -v /vagrant/tests/server.pp
SERVER

  # agent bootstrap
  agent = <<AGENT
#{setup}
puppet apply -v /vagrant/tests/agent.pp
AGENT

  config.vm.define "server" do |n|
    n.vm.box = "centos-64-x64-vbox4210"
    n.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    n.vm.network :forwarded_port, guest: 8153, host: 8153
    n.vm.provision "shell", inline: server
    n.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.define "agent" do |n|
    n.vm.box = "centos-64-x64-vbox4210"
    n.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    n.vm.provision "shell", inline: agent
    n.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
    end
  end

end
