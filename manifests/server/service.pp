class go::server::service {

  service { $::go::server::params::service_name:
    ensure    => $::go::server::service_ensure,
    enable    => $::go::server::service_enable
    subscribe => Class[$::go::server::package]
  }

}
