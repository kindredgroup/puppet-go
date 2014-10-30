$java_packages = $::osfamily ? {
  redhat  => 'java-1.7.0-openjdk',
  debian  => ['openjdk-7-jdk', 'openjdk-7-jre']
}
package { $java_packages: ensure => installed } ->
class { '::go::agent':
  ensure              => present,
  manage_package_repo => true,
} ->
::go::agent::instance { 'goinstance1':
  ensure          => present,
  path            => '/opt/go-instances',
  go_server_host  => 'localhost',
  go_server_port  => '8153'
}
