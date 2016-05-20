require 'spec_helper'
describe 'go::server' do

  context 'with defaults for all parameters' do
    it { should compile }
    it {
      should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MEM=/)
      should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MAX_MEM=/)
      should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MIN_PERM_GEN=/)
      should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MAX_PERM_GEN=/)
    }
  end

  context 'with ensure => absent' do
    let :params do {
      :ensure => 'absent'
    } end
    it { should compile }
  end

  context 'with service_refresh => false' do
    let :params do {
      :service_refresh => false
    } end
    it { should compile }
    it { should contain_service('go-server').with(
      :subscribe => nil
    ) }
  end

  context 'with manage_package_repo => true' do
    let :params do {
      :manage_package_repo => true
    } end
    it { should compile }
    it { should contain_yumrepo('Thoughtworks') }
  end

  context 'with server mem settings' do
    let :params do {
      :server_mem           => '1m',
      :server_max_mem       => '2g',
      :server_min_perm_gen  => '3k',
      :server_max_perm_gen  => '4G'
    } end
    it { should compile }
    it {
      should contain_file('/etc/default/go-server').with_content(/SERVER_MEM=1m/)
      should contain_file('/etc/default/go-server').with_content(/SERVER_MAX_MEM=2g/)
      should contain_file('/etc/default/go-server').with_content(/SERVER_MIN_PERM_GEN=3k/)
      should contain_file('/etc/default/go-server').with_content(/SERVER_MAX_PERM_GEN=4G/)
    }
  end

  context 'with manage_user => false' do
    let :params do {
      :manage_user => false
    } end
    it {
      should contain_file('/var/go').with(
        :ensure => 'directory',
        :owner  => 'go',
        :group  => 'go'
      )
    }
  end

  context 'with manage_user => true' do
    let :params do {
      :manage_user => true
    } end
    it {
      should_not contain_file('/var/go').with(
        :ensure => 'directory',
        :owner  => 'go',
        :group  => 'go'
      )
    }
  end

  context 'with local_password_file => /some/file' do
    let :params do {
      :local_password_file => '/some/file'
    } end
    it { should compile }
    it { should contain_concat('/some/file').with(
      :ensure => 'present'
    ) }
  end

end
