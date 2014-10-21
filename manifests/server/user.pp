class go::server::user {

  if $::go::server::manage_user {
    @group { $::go::server::params::group:
      ensure => $::go::server::ensure
    }
    @user { $::go::server::params::user:
      ensure  => $::go::server::ensure,
      comment => 'Go server user - Managed by Puppet',
      home    => '/var/go',
      gid     => $::go::server::params::group,
      shell   => '/bin/bash'
    }
  }

  if $::go::server::ensure == present {
    Group <| title == $::go::server::params::group |> { ensure => $::go::server::ensure } ->
    User <| title == $::go::server::params::user |> { ensure => $::go::server::ensure }
  } else {
    User <| title == $::go::server::params::user |> { ensure => $::go::server::ensure } ->
    Group <| title == $::go::server::params::group |> { ensure => $::go::server::ensure }
  }

}
