# == Class: go::server::config
#
# Manages the go server configuration files
#
class go::server::config (
  $server_port          = $::go::server::server_port,
  $server_ssl_port      = $::go::server::server_ssl_port,
  $lib_directory        = $::go::server::lib_directory,
  $server_mem           = $::go::server::server_mem,
  $server_max_mem       = $::go::server::server_max_mem,
  $server_min_perm_gen  = $::go::server::server_min_perm_gen,
  $server_max_perm_gen  = $::go::server::server_max_perm_gen,
  $java_home            = $::go::server::java_home,
  $autoregister         = $::go::server::autoregister,
  $autoregister_key     = $::go::server::autoregister_key,
  $enable_plugin_upload = $::go::server::enable_plugin_upload,
) {

  file { $::go::server::params::default_file:
    ensure  => $::go::server::ensure,
    owner   => $::go::server::params::user,
    group   => $::go::server::params::group,
    mode    => '0644',
    content => template("${module_name}/go-server.erb")
  }

  if !$::go::server::manage_user {
    file { '/var/go':
      ensure => directory,
      owner  => 'go',
      group  => 'go'
    }
  }

}
