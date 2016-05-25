$java_packages = $::osfamily ? {
  redhat  => 'java-1.7.0-openjdk',
  debian  => ['openjdk-7-jdk', 'openjdk-7-jre']
}
host { $::hostname: ip => '127.0.0.1' } ->
package { $java_packages: ensure => installed } ->
class { '::go::server':
  ensure                => present,
  manage_package_repo   => true,
  local_auth_enable     => true,
  local_password_file   => '/etc/go/local.pw',
  autoregister          => true,
  autoregister_key      => 'this_is_an_autoregister_key',
  encryption_cipher     => '4c5d1a85ce08abb3',
  ldap_auth_enable      => true,
  ldap_uri              => 'ldap://127.0.0.1',
  ldap_manager_dn       => 'read@domain.com',
  ldap_manager_password => 'readpassword',
  ldap_search_filter    => '(sAMAccountName={0})',
  ldap_base_dn          => 'dc=domain,dc=com',
}

::go::server::local_account { 'a user':
  username => 'foo',
  password => 'bar',
}

if $::osfamily == debian {
  exec { 'apt-get update':
    path   => '/bin:/usr/bin',
    before => Package[$java_packages],
  }
}
