# == Class: go::agent::service
#
# agent service class
#
class go::agent::service {

  service { $::go::agent::params::service_name:
    ensure => $::go::agent::service_ensure,
    enable => $::go::agent::service_enable
  }

}
