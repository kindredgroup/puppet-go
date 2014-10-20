class go::server::service {

  case $::go::server::ensure {
    present: {
      Service[$::go::server::params::service_name] {
        ensure    => $::go::server::service_ensure,
        enable    => $::go::server::service_enable,
        subscribe => Class['::go::server::package']
      }
    }
    absent: {
      Service[$::go::server::params::service_name] {
        ensure => stopped,
        enable => false
      }
    }
  }

  service { $::go::server::params::service_name:
  }

}
