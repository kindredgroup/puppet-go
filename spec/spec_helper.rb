require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily         => 'RedHat',
    :operatingsystem  => 'RedHat',
    :concat_basedir   => '/var/foo',
  }
end

at_exit { RSpec::Puppet::Coverage.report! }
