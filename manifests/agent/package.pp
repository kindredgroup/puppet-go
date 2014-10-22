# == Class: go::agent::package
#
# Manages the go agent package
#
class go::agent::package {

  if $::go::agent::manage_package_repo {
    include ::go::repository
    Package[$::go::agent::params::package_name] {
      require => Class['::go::repository']
    }
  }

  $package_ensure = $::go::agent::ensure ? {
    present => $::go::agent::package_version ? {
      undef   => present,
      default => $::go::agent::package_version
    },
    default => $::go::agent::ensure
  }

  package { $::go::agent::params::package_name:
    ensure => $package_ensure
  }

}
