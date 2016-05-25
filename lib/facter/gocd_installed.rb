Facter.add(:gocd_installed) do
  confine :kernel => 'Linux'
  setcode do
    File.directory? '/usr/share/go-server'
  end
end
