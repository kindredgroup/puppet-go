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

  $server_version = '14.2.0-377'
  $service_name = 'go'

  $download_file_head = 'go-server-'
  $download_file_tail = "${package_arch}.${package_type}"
  $download_base_url = "http://download.go.cd/gocd-${package_type}"

}
