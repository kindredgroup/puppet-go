require 'spec_helper'
describe 'go' do

  context 'with defaults for all parameters' do
    it { should contain_class('go') }
  end

end
