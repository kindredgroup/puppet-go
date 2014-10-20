class go::server::file {

  $directory_ensure = $::go::server::ensure ? {
    present => directory,
    default => $::go::server::ensure
  }

  File {
    owner => $::go::server::params::user,
    group => $::go::server::params::group,
  }
    
  file { $::go::server::lib_directory:
    ensure  => $directory_ensure,
    mode    => '0700'
  }

  file { $::go::server::log_directory:
    ensure  => $directory_ensure,
    mode    => '0755'
  }

  file { $::go::server::config_directory:
    ensure  => $directory_ensure,
    mode    => '0700'
  }

}
