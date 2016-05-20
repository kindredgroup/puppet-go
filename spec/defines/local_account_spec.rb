require 'spec_helper'

describe 'go::server::local_account' do

  context 'with username and password' do
    let(:pre_condition) { 'class {"::go::server": local_password_file => "/some/file" }' }
    let(:title) { 'whatever' }
    let(:params) do {
      :username => 'foo',
      :password => 'bar',
    } end
    it { should compile.with_all_deps }
    it { should contain_concat__fragment('go_password_file_user: foo').with_content("foo:Ys23Ag/5IOWqZCw9QGaVDdHwH00=\n") }
  end

  context 'with username and password when go::server::ensure => absent' do
    let(:pre_condition) { 'class {"::go::server": ensure => absent, local_password_file => "/some/file" }' }
    let(:title) { 'whatever' }
    let(:params) do {
      :username => 'foo',
      :password => 'bar',
    } end
    it { should compile.with_all_deps }
    it { should_not contain_concat__fragment('go_password_file_user: foo') }
  end

end
