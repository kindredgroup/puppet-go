class go::server::service {

  case $::go::server::ensure {
    present: {
      Service[$::go::server::params::service_name] {
        ensure    => $::go::server::service_ensure,
        enable    => $::go::server::service_enable,
      }
      if $::go::server::service_refresh {
        Service[$::go::server::params::service_name] {
          subscribe => [
            Class['::go::server::package'],
            Class['::go::server::config']
          ]
        }
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
