require 'spec_helper'
describe 'go::server' do

  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_package('go-server').with(
      :ensure   => 'present',
      :provider => 'rpm',
      :source   => 'http://download.go.cd/gocd-rpm/go-server-14.2.0-377.noarch.rpm'
    ) }
  end

  context 'with ensure => absent' do
    let :params do {
      :ensure => 'absent'
    } end
    it { should compile }
  end

end
