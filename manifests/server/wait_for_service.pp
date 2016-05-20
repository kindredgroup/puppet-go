class go::server::wait_for_service {

  file { '/usr/share/go-server/health_check.sh':
    ensure  => file,
    owner   => 'go',
    group   => 'go',
    mode    => '0755',
    content => template("${module_name}/health_check-sh.erb"),
  }

  exec { 'wait_for_service_to_start':
    command => '/usr/share/go-server/health_check.sh -u http://localhost:8153 -s 5 -r 20',
    unless  => '/usr/share/go-server/health_check.sh -u http://localhost:8153 -r 0',
    require => File['/usr/share/go-server/health_check.sh'],
  }

}
