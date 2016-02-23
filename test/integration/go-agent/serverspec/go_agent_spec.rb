require 'serverspec'

set :backend, :exec

describe service('go-agent') do
  it { should_not be_enabled.with_level(3) }
  it { should_not be_running }
end

describe port(8153) do
  it { should_not be_listening }
end

describe service('goinstance1') do
  it { should be_running }
  it { should be_enabled.with_level(3) }
end

describe command('sleep 15 && grep localhost.localdomain /opt/go-instances/goinstance1/go-agent/*.log') do
  its(:exit_status) { should eq 0 }
end
