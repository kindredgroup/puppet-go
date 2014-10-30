# == Class: go::repository
#
# Manages the go package repository
#
class go::repository {

  case $::osfamily {
    redhat: {
      yumrepo { 'Thoughtworks':
        descr       => 'Thoughtworks Yum Repository',
        enabled     => '1',
        baseurl     => 'http://download.go.cd/gocd-rpm/',
        includepkgs => 'absent',
        gpgcheck    => '0',
        gpgkey      => 'absent',
        priority    => '99'
      }
    }
    debian: {
      file { '/etc/apt/sources.list.d/thoughtworks.list':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'deb http://download.go.cd/gocd-deb/ /',
      }
      exec {'go_run_apt_get_update':
        command     => 'apt-get update',
        path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        refreshonly => true,
        subscribe   => File['/etc/apt/sources.list.d/thoughtworks.list']
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

}
