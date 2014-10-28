require 'spec_helper'

describe 'go::agent::instance' do

  context 'with required settings' do
    let(:pre_condition) { 'include ::go::agent' }
    let(:title) { 'gouser' }
    let(:params) do {
      :path           => '/opt/go',
      :go_server_host => 'go.example.com',
      :go_server_port => '9999'
    } end
    it { should compile.with_all_deps }
    it { should contain_file('/opt/go/gouser') }
    it { should contain_user('gouser') }
    it { should contain_group('gouser') }
    it { should_not contain_file('/opt/go/gouser/config/autoregister.properties') }
    it {
      should contain_file('/etc/init.d/gouser').with_content(/USER="gouser"\n/)
      should contain_file('/etc/init.d/gouser').with_content(/INSTANCE_NAME="gouser"\n/)
      should contain_file('/etc/init.d/gouser').with_content(/PID_DIR="\/var\/run\/gouser"\n/)
      should contain_file('/etc/init.d/gouser').with_content(/PID_FILE="\/var\/run\/gouser\/go-agent.pid"\n/)
    }
    it {
      should contain_file('/etc/default/gouser').with_content(/export GO_SERVER=go.example.com\n/)
      should contain_file('/etc/default/gouser').with_content(/export GO_SERVER_PORT=9999\n/)
      should contain_file('/etc/default/gouser').with_content(/export JAVA_HOME=\/usr\n/)
      should contain_file('/etc/default/gouser').with_content(/export AGENT_WORK_DIR=\/opt\/go\/gouser\/go-agent\n/)
      should contain_file('/etc/default/gouser').with(
        :notify => 'Service[gouser]'
      )
    }
    it { should contain_file('/usr/share/go-agent/gouser.sh') }
    it { should contain_service('gouser') }
  end

  context 'with memory settings' do
    let(:pre_condition) { 'include ::go::agent' }
    let(:title) { 'gouser' }
    let(:params) do {
      :path           => '/opt/go',
      :go_server_host => 'go.example.com',
      :go_server_port => '9999',
      :agent_mem      => '512m',
      :agent_max_mem  => '1g'
    } end
    it {
      should contain_file('/etc/default/gouser').with_content(/export AGENT_MEM=512m\n/)
      should contain_file('/etc/default/gouser').with_content(/export AGENT_MAX_MEM=1g\n/)
    }
  end

  context 'with autoregister and settings' do
    let(:pre_condition) { 'include ::go::agent' }
    let(:title) { 'gouser' }
    let(:params) do {
      :path                   => '/opt/go',
      :go_server_host         => 'go.example.com',
      :go_server_port         => '9999',
      :autoregister           => true,
      :autoregister_key       => 'fookey',
      :autoregister_resources => ['resourceA', 'resourceB']
    } end
    it {
      should contain_file('/opt/go/gouser/go-agent/autoregister.properties').with_content(/agent.auto.register.key=fookey\n/)
      should contain_file('/opt/go/gouser/go-agent/autoregister.properties').with_content(/agent.auto.register.resources=resourceA,resourceB\n/)
      should_not contain_file('/opt/go/gouser/go-agent/autoregister.properties').with_content(/agent.auto.register.environments=/)
    }
  end

  context 'autoregister with no autoregister_key setting' do
    let(:pre_condition) { 'include ::go::agent' }
    let(:title) { 'gouser' }
    let(:params) do {
      :path                   => '/opt/go',
      :go_server_host         => 'go.example.com',
      :go_server_port         => '9999',
      :autoregister           => true,
      :autoregister_resources => ['resourceA', 'resourceB']
    } end
    it {
      expect { should compile }.to raise_error()
    }
  end

  context 'autoregister with no autoregister_resources setting' do
    let(:pre_condition) { 'include ::go::agent' }
    let(:title) { 'gouser' }
    let(:params) do {
      :path             => '/opt/go',
      :go_server_host   => 'go.example.com',
      :go_server_port   => '9999',
      :autoregister     => true,
      :autoregister_key => 'fookey'
    } end
    it {
      expect { should compile }.to raise_error()
    }
  end

end
