# == Class: go::server::file
#
# Manages go server related files
#
class go::server::file (
  $local_password_file = $::go::server::local_password_file,
  $encryption_cipher   = $::go::server::encryption_cipher,
) {

  $directory_ensure = $::go::server::ensure ? {
    present => directory,
    default => $::go::server::ensure
  }

  $password_file_ensure = $local_password_file ? {
    undef   => absent,
    default => $::go::server::ensure,
  }

  if $directory_ensure == absent {
    File {
      force => $::go::server::force
    }
  }

  File {
    owner => $::go::server::params::user,
    group => $::go::server::params::group,
  }

  file { $::go::server::lib_directory:
    ensure => $directory_ensure,
    mode   => '0700'
  }

  file { $::go::server::log_directory:
    ensure => $directory_ensure,
    mode   => '0755'
  }

  file { $::go::server::config_directory:
    ensure => $directory_ensure,
    mode   => '0700'
  }

  if $local_password_file != undef {
    concat { $local_password_file:
      ensure => $password_file_ensure,
      owner  => $::go::server::params::user,
      group  => $::go::server::params::group,
      mode   => '0600',
    }
    if $password_file_ensure == present {
      Concat::Fragment <| tag == 'go::server::local_account' |>
    }
  }

  if $encryption_cipher {
    file { "${::go::server::config_directory}/cipher":
      ensure  => $::go::server::ensure,
      content => $encryption_cipher,
    }
  }

}
