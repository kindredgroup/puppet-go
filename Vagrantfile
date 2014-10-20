Vagrant.configure("2") do |config|

  $script = <<SCRIPT
puppet apply -e "package { 'rubygems': ensure => installed}"
puppet apply -e "package { 'librarian-puppet': ensure => '1.4.0', provider => 'gem' }"
puppet apply -e "package { 'java-1.7.0-openjdk': ensure => installed }"
cd /vagrant
librarian-puppet install --path /etc/puppet/modules
rm -rf /etc/puppet/modules/go
cp -r /vagrant /etc/puppet/modules/go
puppet apply -e "class { '::go::server': ensure => present }"
SCRIPT

  config.vm.box = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  config.vm.network :forwarded_port, guest: 8153, host: 8153

  config.vm.provision "shell", inline: $script

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

end
