require 'spec_helper'
describe 'go::server' do

  context 'with defaults for all parameters' do
    it { should compile }
  end

  context 'with ensure => absent' do
    let :params do {
      :ensure => 'absent'
    } end
    it { should compile }
  end

end
