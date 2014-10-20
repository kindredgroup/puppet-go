class go::server::params {

  case $::operatingsystem {
    centos, redhat: {
      $package_type = 'rpm'
      $package_arch = '.noarch'
      $provider = 'rpm'
    }
    debian, ubuntu: {
      $package_type = 'deb'
      $package_arch = ''
      $provider = 'dpkg'
    }
    default: { fail("Unsupported operatingsystem: ${::operatingsystem}") }
  }

  $service_name = 'go-server'
  $package_name = 'go-server'
  $package_version = '14.2.0-377'

  $lib_directory = '/var/lib/go-server'
  $log_directory = '/var/log/go-server'
  $config_directory = '/etc/go'
  $default_file = '/etc/default/go-server'

  $server_port = '8153'
  $server_ssl_port = '8154'
  $java_home = '/usr'
  
  $download_file_head = 'go-server'
  $download_file_tail = "${package_arch}.${package_type}"
  $download_base_url = "http://download.go.cd/gocd-${package_type}"

}
