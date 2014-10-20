Vagrant.configure("2") do |config|

  $script = <<SCRIPT
bundle install --path .gems
bundle exec librarian-puppet install
bundle exec puppet apply -e "include ::go::server"
SCRIPT

  config.vm.box = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  config.vm.network :forwarded_port, guest: 8153, host: 8153

  config.vm.provision "shell", inline: $script

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "512"]
  end

end
