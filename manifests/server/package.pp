# == Class: go::server::package
#
# Manages the go server package
#
class go::server::package {

  if $::go::server::manage_package_repo {
    include ::go::repository
    if $::osfamily == debian {
      Package[$::go::server::params::package_name] {
        install_options => '--force-yes'
      }
    }
    Package[$::go::server::params::package_name] {
      require => Class['::go::repository']
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
