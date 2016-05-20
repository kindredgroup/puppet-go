require 'spec_helper'

describe 'gocd_encrypt' do

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params('4c5d1a85ce08abb3', 'readpassword').and_return('kcsuLE6Za3HGuy4pFVFTjQ==') }

  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('4c5d1a85ce08abb3').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('','foo').and_raise_error(Puppet::ParseError, /cipher key cannot be empty/i) }
  it { is_expected.to run.with_params('foo','').and_raise_error(Puppet::ParseError, /password cannot be empty/i) }

end
