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
    mode    => '0700'
  }

  file { $::go::server::config_directory:
    ensure  => $directory_ensure,
    mode    => '0700'
  }

  file { $::go::server::params::default_file:
    ensure  => $::go::server::ensure,
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
