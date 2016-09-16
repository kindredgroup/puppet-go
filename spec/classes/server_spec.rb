require 'spec_helper'
describe 'go::server' do

  context 'with defaults for all parameters' do
    it { should compile }
    it { should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MEM=/) }
    it { should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MAX_MEM=/) }
    it { should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MIN_PERM_GEN=/) }
    it { should_not contain_file('/etc/defaults/go-server').with_content(/SERVER_MAX_PERM_GEN=/) }
    it { should_not contain_class('go::server::config::xml') }
    it { should_not contain_class('go::server::config::xml::dependencies') }
    it { should_not contain_class('go::server::wait_for_service') }
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
    it { should contain_concat('/some/file').with_ensure('present') }
    it { should_not contain_augeas('set_password_file_authentication') }
  end

  context 'with local_auth_enable => true and local_password_file => /some/file' do
    let :params do {
      :local_auth_enable   => true,
      :local_password_file => '/some/file'
    } end
    it { should compile }
    it { should contain_concat('/some/file').with_ensure('present') }
    it { should contain_augeas('set_password_file_authentication') }
  end

  context 'with autoregister => true and autoregister_key => somekey' do
    let :params do {
      :autoregister     => true,
      :autoregister_key => 'somekey'
    } end
    it { should compile }
    it { should contain_augeas('set_cruise_autoregister').with_changes('set agentAutoRegisterKey somekey') }
  end

  context 'with ldap_auth_enable => true and no additional ldap config' do
    let :params do {
      :ldap_auth_enable => true,
    } end
    it { should_not compile }
  end

  context 'with ldap_auth_enable => true and all required parameters set' do
    let :params do {
      :encryption_cipher     => '123456',
      :ldap_auth_enable      => true,
      :ldap_uri              => 'ldap://ldapserver.company.com',
      :ldap_manager_dn       => 'read@company.com',
      :ldap_manager_password => 'readpassword',
      :ldap_base_dn          => 'dc=company,dc=com',
    } end
    it { should compile }
    it { should contain_class('go::server::config::xml') }
    it { should contain_augeas('set_ldap_authentication') }
  end

  context 'with enable_plugin_upload => true' do
    let :params do {
      :enable_plugin_upload => true,
    } end
    it { should compile }
    it { should contain_file('/etc/default/go-server').with_content(/GO_SERVER_SYSTEM_PROPERTIES=/) }
  end

end
