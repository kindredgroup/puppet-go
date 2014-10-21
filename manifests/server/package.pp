# == Class: go::server::package
#
# Manages the go server package
#
class go::server::package {

  if $::go::server::manage_package_repo {
    class { '::go::repository':
      before => Package[$::go::server::params::package_name]
    }
  }

  $package_ensure = $::go::server::ensure ? {
    present => $::go::server::package_version ? {
      undef   => present,
      default => $::go::server::package_version
    },
    default => $::go::server::ensure
  }

  package { $::go::server::params::package_name:
    ensure => $package_ensure
  }

}
