class go::server::package {

  if !$::go::server::package_from_repo {
    $package_filename = "${::go::server::params::download_file_head}-${::go::server::version}${::go::server::params::download_file_tail}"
    $package_source = "${::go::server::params::download_base_url}/${package_filename}"
    Package[$::go::server::package_name] {
      ensure => $::go::server::ensure,
      source => $package_source
    }
  } else {
    $package_ensure = $::go::server::ensure ? {
      present => $::go::server::package_version ? {
        undef   => present,
        default => $::go::server::package_version
      },
      default => $::go::server::ensure
    }
    Package[$::go::server::package_name] {
      ensure => $package_ensure
    }
  }

  package { $::go::server::package_name:
  }

}
