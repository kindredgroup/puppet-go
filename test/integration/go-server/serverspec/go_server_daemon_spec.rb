require 'serverspec'

set :backend, :exec

describe service('go-server') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8153) do
  it { should be_listening }
end
