source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3', '<=3.5.1']
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
gem 'librarian-puppet'
gem 'test-kitchen'
gem 'kitchen-vagrant'
gem 'kitchen-puppet', :git => 'https://github.com/neillturner/kitchen-puppet.git'
gem 'vagrant-wrapper'
