class go::server (
  $ensure             = 'present',
  $service_ensure     = 'running',
  $service_enable     = true,
  $package_from_repo  = false,
  $package_name       = $::go::server::params::package_name,
  $package_source     = $::go::server::params::package_source,
  $package_version    = $::go::server::params::package_version
) inherits ::go::server::params {

  anchor { '::go::server::begin': } ->
  class { '::go::server::user': } ->
  class { '::go::server::package': } ->
  class { '::go::server::config': } ->
  class { '::go::server::service': } ->
  anchor { '::go::server::end': }

}
