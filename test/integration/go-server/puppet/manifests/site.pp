package { 'java-1.7.0-openjdk': ensure => installed } ->
class { '::go::server':
  ensure              => present,
  manage_package_repo => true,
}
