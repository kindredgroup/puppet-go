class go::server (
  $ensure               = 'present',
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_refresh      = true,
  $package_from_repo    = false,
  $package_name         = $::go::server::params::package_name,
  $package_version      = $::go::server::params::package_version,
  $lib_directory        = $::go::server::params::lib_directory,
  $log_directory        = $::go::server::params::log_directory,
  $config_directory     = $::go::server::params::config_directory,
  $server_port          = $::go::server::params::server_port,
  $server_ssl_port      = $::go::server::params::server_ssl_port,
  $java_home            = $::go::server::params::java_home,
  $server_mem           = undef,
  $server_max_mem       = undef,
  $server_min_perm_gen  = undef,
  $server_max_perm_gen  = undef
) inherits ::go::server::params {

  # input validation
  validate_re($ensure, ['present', 'absent'], "Invalid ensure value ${ensure}. Valid values: present, absent")
  validate_re($service_ensure, ['running', 'stopped', 'unmanaged'], "Invalid service_ensure value ${service_ensure}. Valid values: running, stopped, unmanaged")
  validate_bool($service_enable)
  validate_bool($package_from_repo)

  # input validation optional parameters
  $memory_regex = '[0-9]+[gGmMkK]'
  if $server_mem {
    validate_re($server_mem, $memory_regex, "Invalid server_mem value ${server_mem}. Leave it off or set to ${memory_regex}")
  }
  if $server_max_mem {
    validate_re($server_max_mem, $memory_regex, "Invalid server_max_mem value ${server_max_mem}. Leave it off or set to ${memory_regex}")
  }
  if $server_min_perm_gen {
    validate_re($server_min_perm_gen, $memory_regex, "Invalid server_min_perm_gen value ${server_min_perm_gen}. Leave it off or set to ${memory_regex}")
  }
  if $server_max_perm_gen {
    validate_re($server_max_perm_gen, $memory_regex, "Invalid server_max_perm_gen value ${server_max_perm_gen}. Leave it off or set to ${memory_regex}")
  }

  # module resources
  case $ensure {
    present: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::user': } ->
      class { '::go::server::package': } ->
      class { '::go::server::file': } ->
      class { '::go::server::config': } ->
      class { '::go::server::service': } ->
      anchor { '::go::server::end': }
    }
    absent: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::service': } ->
      class { '::go::server::config': } ->
      class { '::go::server::file': } ->
      class { '::go::server::package': } ->
      class { '::go::server::user': } ->
      anchor { '::go::server::end': }
    }
    default: {}
  }

}
