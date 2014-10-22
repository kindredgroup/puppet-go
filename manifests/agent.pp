# == Class: go::agent
#
# Manages the agent component of Thoughtworks Go
# To manage individual instances see the defined type go::agent::instance
#
# === Parameters
#
# [*ensure*]
#   Traditional ensurable, supports teardown via absent
#   Valid values: string - present, absent
#
# [*service_ensure*]
#   Manage the state of the go-agent daemon
#   Valid values: string - running, stopped, unmanaged
#
# [*service_enable*]
#   Manage if go-agent daemon should start on boot
#   Valid values: boolean
#
# [*manage_package_repo*]
#   Manage Thoughtworks package repository
#   Valid values: boolean
#
# [*package_version*]
#   Which version of package to install. Defaults to just 'present'
#   Valid values: string - package type ensure
#
# === Examples
#
#   class { '::go::agent':
#     ensure              => present,
#     manage_package_repo => true
#   }
#
class go::agent (
  $ensure               = 'present',
  $manage_package_repo  = false,
  $package_version      = 'present',
  $service_ensure       = 'stopped',
  $service_enable       = false
) inherits ::go::agent::params {

  # input validation
  validate_re($ensure, ['present', 'absent'], "Invalid ensure value ${ensure}. Valid values: present, absent")

  # module resources
  anchor { '::go::agent::begin': } ->
  class { '::go::agent::package': } ->
  class { '::go::agent::service': } ->
  anchor { '::go::agent::end': }

}
