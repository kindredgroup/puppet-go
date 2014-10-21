# == Class: go::repository
#
# Manages the go package repository
#
class go::repository {

  case $::operatingsystem {
    centos, redhat: {
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
    debian, ubuntu: {
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }

}
