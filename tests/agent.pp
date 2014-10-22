class { '::go::agent':
  ensure              => present,
  manage_package_repo => true
}

::go::agent::instance { ['agent1', 'agent2']:
  ensure                 => present,
  path                   => '/opt/go',
  go_server_host         => '127.0.0.1',
  go_server_port         => '8153',
  autoregister           => true,
  autoregister_key       => 'foobar',
  autoregister_resources => ['shell', 'python']
}
