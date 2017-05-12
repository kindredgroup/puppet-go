# == Define: go_agent::instance
#
# Manages an individual go agent sandbox instance
#
# === Parameters:
#
# [*namevar*]
#   Name of instance, typically something like "goagent1"
#   Will also be used as the username of the user running the instance
#   Valid values: string
#
# [*path*]
#   Path to the user home directory
#   Valid values: string - path
#
# [*go_server_host*]
#   FQDN or IP of go server
#   Valid values: string - ip or hostname
#
# [*go_server_port*]
#   Port number of go server
#   Valid values: string - port number
#
# [*mode*]
#   File mode on instance home dir and work dir
#   Valid values: string - XXXX mode
#
# [*java_home*]
#   Path to java home
#   Valid values: string - path
#
# [*autoregister*]
#   Toggle go agent autoregistration
#   Valid values: boolean
#
# [*autoregister_key*]
#   The configured autoregister key on the go server
#   Valid values: string - key
#
# [*autoregister_resources*]
#   A list of resources used by the go agent
#   Valid values: array of strings
#
# [*autoregister_env*]
#   Environment that go agent will belong to. Leave unset for no environment
#   Valid values: string - environment name
#
# [*manage_user*]
#   If the instance user and home directory should be managed
#   Valid values: boolean
#
# [*service_ensure*]
#   Service state of go agent instance
#   Valid values: string - running, stopped, unmanaged (ie: dont care)
#
# [*service_enable*]
#   If the go agent instance service should be auto started on boot
#   Valid values: boolean
#
# [*service_refresh*]
#   If the go agent instance service should be restarted on config changes
#   Valid values: boolean
#
# [*agent_mem*]
#   The AGENT_MEM setting for this go agent
#   Valid values: string - memsize
#
# [*agent_max_mem*]
#   The AGENT_MAX_MEM setting for this go agent
#   Valid values: string - memsize
#
# [*ensure*]
#   Ensurable
#
# === Sample usage:
#
# go_agent::instance { "goagent1":
#   ensure          => present,
#   path            => '/var/go',
#   go_server_host  => 'go.example.com',
#   go_server_port  => '80',
# }
#
define go::agent::instance (
  $path,
  $go_server_host,
  $go_server_port,
  $mode                   = '0755',
  $java_home              = '/usr',
  $autoregister           = false,
  $autoregister_key       = undef,
  $autoregister_resources = undef,
  $autoregister_env       = undef,
  $autoregister_hostname  = $name,
  $manage_user            = true,
  $service_ensure         = 'running',
  $service_enable         = true,
  $service_refresh        = true,
  $agent_mem              = undef,
  $agent_max_mem          = undef,
  $ensure                 = 'present',
) {

  # input validation
  validate_re($ensure, ['present', 'absent'], "Invalid ensure value ${ensure}. Valid values: present, absent")
  validate_re($service_ensure, ['running', 'stopped', 'unmanaged'], "Invalid service_ensure value ${service_ensure}. Valid values: running, stopped, unmanaged")
  validate_bool($autoregister)
  validate_bool($service_enable)

  if $autoregister {
    validate_re($autoregister_key, ['^[0-9a-zA-Z]+'], 'Parameter autoregister_key must be set when using autoregister')
    validate_array($autoregister_resources)
  }

  if $agent_mem {
    validate_re($agent_mem, '[0-9]+[mMkKgG]')
  }

  if $agent_max_mem {
    validate_re($agent_max_mem, '[0-9]+[mMkKgG]')
  }

  $user_ensure = $ensure
  $directory_ensure = $ensure ? {
    present => directory,
    default => $ensure
  }
  $service_ensure_real = $service_ensure ? {
    unmanaged => undef,
    default   => $service_ensure
  }
  $user = $name
  $home = "${path}/${name}"
  $work_dir = "${home}/go-agent"

  if $manage_user {
    exec { "create_parent_dir_${name}":
      command => "mkdir -p ${path}",
      path    => ['/bin', '/usr/bin'],
      creates => $path
    }

    # if user is already defined as a virtual resource, realize it
    if defined(User[$user]) and defined(Group[$user]) {
      Group <| title == $user |> ->
      User <| title == $user |> {
        home  => $home
      }
    } else {
      user { $user:
        ensure     => $user_ensure,
        comment    => 'Go agent user - Managed by puppet',
        home       => $home,
        gid        => $user,
        managehome => false
      }
      group { $user:
        ensure  => $user_ensure,
      }
    }

    file { [$home, $work_dir]:
      ensure  => $directory_ensure,
      owner   => $user,
      group   => $user,
      mode    => $mode,
      require => Exec["create_parent_dir_${name}"]
    }
  }

  Exec {
    path => ['/bin', '/usr/bin']
  }

  # all file resources in this scope should
  # be applied before service
  File {
    before  => Service[$name]
  }

  if $autoregister {
    file { "${work_dir}/config":
      ensure  => $directory_ensure,
      owner   => $user,
      group   => $user,
      mode    => $mode,
      require => File[$work_dir]
    } ->
    file { "${work_dir}/config/autoregister.properties":
      ensure  => $ensure,
      owner   => $user,
      group   => $user,
      mode    => '0600',
      content => template("${module_name}/autoregister.properties.erb")
    }
    if $service_refresh {
      File["${work_dir}/config/autoregister.properties"] {
        notify => Service[$name]
      }
    }
  }

  file { "/etc/init.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/go-agent-service.erb")
  }

  if $service_refresh {
    File["/etc/default/${name}"] {
      notify => Service[$name]
    }
  }
  file { "/etc/default/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/go-agent-defaults.erb")
  }

  file { "/usr/share/go-agent/${name}.sh":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/go-agent-sh.erb")
  }

  case $::osfamily {
    redhat: {
      Service[$name] {
        provider => 'init'
      }
    }
    default: {}
  }

  service { $name:
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasrestart => false,
    hasstatus  => true,
  }

}
