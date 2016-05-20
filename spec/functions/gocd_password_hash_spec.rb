require 'spec_helper'

describe 'gocd_password_hash' do

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params('badger').and_return('ThmbShxAtJepX80c2JY1FzOEmUk=') }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, /password cannot be empty/i) }

end
