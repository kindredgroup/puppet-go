# == Class: go::server
#
# Manages the server component of Thoughtworks Go
#
# === Parameters
#
# [*ensure*]
#   Traditional ensurable, supports teardown via absent
#   Valid values: string - present, absent
#
# [*service_ensure*]
#   Manage the state of the go server daemon
#   Valid values: string - running, stopped, unmanaged
#
# [*service_enable*]
#   Manage if go server daemon should start on boot
#   Valid values: boolean
#
# [*service_refresh*]
#   Manage if go server daemon should be restarted automatically
#   on configuration and package changes
#   Valid values: boolean
#
# [*manage_package_repo*]
#   Manage Thoughtworks package repository
#   Valid values: boolean
#
# [*manage_user*]
#   Use user and group definition declared in this module
#   Valid values: boolean
#
# [*force*]
#   On teardown, remove directory trees
#   Valid values: boolean
#
# [*package_version*]
#   Which version of package to install. Defaults to just 'present'
#   Valid values: string - package type ensure
#
# [*lib_directory*]
#   Valid values: string - path
#
# [*log_directory*]
#   Valid values: string - path
#
# [*server_port*]
#   Valid values: string - port number
#
# [*server_ssl_port*]
#   Valid values: string - port number
#
# [*java_home*]
#   Valid values: string - path
#
# [*server_mem*]
#   SERVER_MEM setting, leave undef to use default in Go
#   Valid values: string - sizeUNIT (ex 1G)
#
# [*server_max_mem*]
#   SERVER_MAX_MEM setting, leave undef to use default in Go
#   Valid values: string - sizeUNIT (ex 1G)
#
# [*server_min_perm_gen*]
#   SERVER_MIN_PERM_GEN settings, leave undef to use default in Go
#   Valid values: string - sizeUNIT (ex 1G)
#
# [*server_max_perm_gen*]
#   SERVER_MAX_PERM_GEN settings, leave undef to use default in Go
#   Valid values: string - sizeUNIT(ex 1G)
#
# [*local_password_file*]
#   Manages the content of a password file in Go.
#   Note that this current does not modify the cruise-config.xml to accept
#   local password file authentication, that is expected to be handled manually
#   Use the define go::server::local_account to manage individual user entries
#   Valid values: undef or absolute path to file
#
# === Examples
#
#   class { '::go::server':
#     ensure              => present,
#     manage_package_repo => true,
#     manage_user         => true,
#     force               => true
#   }
#
class go::server (
  $ensure               = 'present',
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_refresh      = true,
  $manage_package_repo  = false,
  $manage_user          = false,
  $force                = false,
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
  $server_max_perm_gen  = undef,
  $autoregister         = false,
  $autoregister_key     = undef,
  $local_password_file  = undef,
) inherits ::go::server::params {

  # input validation
  validate_re($ensure, ['present', 'absent'], "Invalid ensure value ${ensure}. Valid values: present, absent")
  validate_re($service_ensure, ['running', 'stopped', 'unmanaged'], "Invalid service_ensure value ${service_ensure}. Valid values: running, stopped, unmanaged")
  validate_bool($service_enable)
  validate_bool($manage_package_repo)

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
  if $local_password_file {
    validate_absolute_path($local_password_file)
  }

  # module resources
  case $ensure {
    present: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::user': } ->
      class { '::go::server::package': } ->
      class { '::go::server::file': } ->
      class { '::go::server::config': } ->
      class { '::go::server::autoregister': } ->
      class { '::go::server::service': } ->
      anchor { '::go::server::end': }
    }
    absent: {
      anchor { '::go::server::begin': } ->
      class { '::go::server::service': } ->
      class { '::go::server::user': } ->
      class { '::go::server::config': } ->
      class { '::go::server::file': } ->
      class { '::go::server::package': } ->
      anchor { '::go::server::end': }
    }
    default: {}
  }

}
