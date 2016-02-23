require 'serverspec'

set :backend, :exec

describe 'service go-server' do
  it "should be running", :retry => 20, :retry_wait => 10 do
    expect(service('go-server')).to be_running
  end
  it "should be enabled" do
    expect(service('go-server')).to be_enabled.with_level(3)
  end
end

describe 'ports' do
  [8153, 8154].each do |pn|
    it "should be listening on #{pn}", :retry => 20, :retry_wait => 10 do
      expect(port(pn)).to be_listening
    end
  end
end
