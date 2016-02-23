source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : '3.7.3'

group :rspec, :kitchen do
  gem 'librarian-puppet', '2.1.0'
  gem 'puppet_forge', '< 2.0.0'
  gem 'puppet', puppetversion
  gem 'rspec_junit_formatter'
  gem 'puppet-blacksmith'
  gem 'net-ssh', '~> 2.0'
end

group :rspec do
  gem 'puppetlabs_spec_helper', '>= 0.1.0'
  gem 'puppet-lint', '< 1.1.0'
  gem 'facter', '>= 1.7.0'
  gem 'rspec-puppet'
  gem 'puppet-syntax'
  gem 'metadata-json-lint'
  gem 'rspec', '~> 3.3'
end

group :kitchen do
  gem 'test-kitchen'
  gem 'kitchen-puppet'
  gem 'kitchen-docker', '< 2.2.0'  # https://github.com/portertech/kitchen-docker/issues/148
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end
