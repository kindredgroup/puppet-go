source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3', '<=3.5.1']

group :rspec, :kitchen do
  gem 'librarian-puppet'
  gem 'puppet', puppetversion
end

group :rspec do
  gem 'puppetlabs_spec_helper', '>= 0.1.0'
  gem 'puppet-lint', '>= 0.3.2'
  gem 'facter', '>= 1.7.0'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
end

group :kitchen do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-puppet', :git => 'https://github.com/neillturner/kitchen-puppet.git'
  gem 'vagrant-wrapper'
end
