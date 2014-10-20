class go::server::config (
  $server_port          = $::go::server::server_port,
  $server_ssl_port      = $::go::server::server_ssl_port,
  $lib_directory        = $::go::server::lib_directory,
  $server_mem           = $::go::server::server_mem,
  $server_max_mem       = $::go::server::server_max_mem,
  $server_min_perm_gen  = $::go::server::server_min_perm_gen,
  $server_max_perm_gen  = $::go::server::server_max_perm_gen,
  $java_home            = $::go::server::java_home,
) {

  file { $::go::server::params::default_file:
    ensure  => $::go::server::ensure,
    owner   => $::go::server::params::user,
    group   => $::go::server::params::group,
    mode    => '0644',
    content => template("${module_name}/go-server.erb")
  }

  if $::go::server::ensure == present {
    file_line { 'log_directory_server':
      path  => "${::go::server::config_directory}/log4j.properties",
      line  => "log4j.appender.FileAppender.File=${::go::server::log_directory}/go-server.log",
      match => '^log4j.appender.FileAppender.File='
    }

    file_line { 'log_directory_shine':
      path  => "${::go::server::config_directory}/log4j.properties",
      line  => "log4j.appender.ShineFileAppender.File=${::go::server::log_directory}/go-server.log",
      match => '^log4j.appender.ShineFileAppender.File='
    }
  }

}
