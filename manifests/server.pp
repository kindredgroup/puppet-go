class go::server (
  $ensure             = 'present',
  $service_ensure     = 'running',
  $service_enable     = true,
  $package_from_repo  = false,
  $package_name       = $::go::server::params::package_name,
  $package_version    = $::go::server::params::package_version
) inherits ::go::server::params {

  # input validation
  validate_re($ensure, ['present', 'absent'], "Invalid ensure value ${ensure}. Valid values: present, absent")
  validate_re($service_ensure, ['running', 'stopped', 'unmanaged'], "Invalid service_ensure value ${service_ensure}. Valid values: running, stopped, unmanaged")
  validate_bool($service_enable)
  validate_bool($package_from_repo)

  # module resources
  case $ensure {
    present: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::user': } ->
      class { '::go::server::package': } ->
      class { '::go::server::config': } ->
      class { '::go::server::service': } ->
      anchor { '::go::server::end': }
    }
    absent: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::service': } ->
      class { '::go::server::config': } ->
      class { '::go::server::package': } ->
      class { '::go::server::user': } ->
      anchor { '::go::server::end': }
    }
    default: {}
  }

}
