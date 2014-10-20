Vagrant.configure("2") do |config|

  $script = <<SCRIPT
puppet apply -e "package { 'rubygems': ensure => installed}"
#puppet apply -e "package { 'bundler': ensure => installed, provider => 'gem' }"
puppet apply -e "package { 'librarian-puppet': ensure => '1.4.0', provider => 'gem' }"

cd /vagrant
#bundle install --path .gems
#bundle exec librarian-puppet install
#bundle exec puppet apply -e "include ::go::server"
librarian-puppet install --path /etc/puppet/modules
rm -rf /etc/puppet/modules/go
cp -r /vagrant /etc/puppet/modules/go
puppet apply -e "include ::go::server"
SCRIPT

  config.vm.box = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  config.vm.network :forwarded_port, guest: 8153, host: 8153

  config.vm.provision "shell", inline: $script

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "512"]
  end

end
