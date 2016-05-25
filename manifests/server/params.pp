# == Class: go::server::params
#
# Parameters class for go server
#
class go::server::params {

  $user = 'go'
  $group = 'go'

  $service_name = 'go-server'
  $package_name = 'go-server'
  $package_version = present

  $lib_directory = '/var/lib/go-server'
  $log_directory = '/var/log/go-server'
  $config_directory = '/etc/go'
  $default_file = '/etc/default/go-server'

  $server_port = '8153'
  $server_ssl_port = '8154'
  $java_home = '/usr'

  $augeas_packages = $::osfamily ? {
    redhat  => ['augeas', 'ruby-augeas'],
    debian  => ['ruby-augeas'],
    default => []
  }

}
