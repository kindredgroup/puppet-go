case $::osfamily {
  redhat: {
    package { 'curl': ensure => present } ->
    exec { 'curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm > /tmp/jdk-8u51-linux-x64.rpm':
      path    => '/bin:/usr/bin',
      creates => '/tmp/jdk-8u51-linux-x64.rpm',
    }
    package { 'jdk1.8.0_51':
      ensure   => installed,
      source   => '/tmp/jdk-8u51-linux-x64.rpm',
      provider => 'rpm',
      before   => Class['::go::agent'],
    }
    $java_home = '/usr/java/jdk1.8.0_51'
  }
  debian: {
    # TODO
  }
  default: {}
}

class { '::go::agent':
  ensure              => present,
  manage_package_repo => true,
} ->
::go::agent::instance { 'goinstance1':
  ensure          => present,
  path            => '/opt/go-instances',
  go_server_host  => 'localhost.localdomain',
  go_server_port  => '8153',
  java_home       => $java_home,
}
