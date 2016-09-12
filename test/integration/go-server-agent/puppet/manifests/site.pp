#$go_version = '16.6.0-3590'
$go_version = 'present'

case $::osfamily {
  redhat: {
    package { ['curl', 'unzip']: ensure => present } ->
    exec { 'curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm > /tmp/jdk-8u51-linux-x64.rpm':
      path    => '/bin:/usr/bin',
      creates => '/tmp/jdk-8u51-linux-x64.rpm',
    } ->
    package { 'jdk1.8.0_51':
      ensure   => installed,
      source   => '/tmp/jdk-8u51-linux-x64.rpm',
      provider => 'rpm',
      before   => Class['::go::server'],
    }
    $java_home = '/usr/java/jdk1.8.0_51'
  }
  debian: {
    # TODO
  }
  default: {}
}

host { $::hostname: ip => '127.0.0.1' } ->

class { '::go::server':
  ensure              => present,
  manage_package_repo => true,
  local_auth_enable   => false,
  autoregister        => true,
  autoregister_key    => 'autoregisterkey',
  java_home           => $java_home,
  package_version     => $go_version,
} ->

class { '::go::agent':
  ensure              => present,
  manage_package_repo => true,
  package_version     => $go_version,
} ->

::go::agent::instance { 'goinstance1':
  ensure                 => present,
  path                   => '/opt/go-instances',
  go_server_host         => $::hostname,
  go_server_port         => '8153',
  java_home              => $java_home,
  autoregister           => true,
  autoregister_key       => 'autoregisterkey',
  autoregister_resources => ['build'],
}
