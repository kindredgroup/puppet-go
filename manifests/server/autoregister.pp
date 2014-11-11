# == Class: go::server::autoregister
#
# Manages server autoregistration
#
class go::server::autoregister {

  if $::go::server::autoregister {

    validate_re($::go::server::autoregister_key, '[0-9a-zA-Z]', "Invalid parameter autoregister_key value ${::go::server::autoregister_key}. Must be alphanumerical")

    # it ain't pretty but it works and is totally optional
    exec { 'add_autoregister_key':
      command => "head -3 ${::go::server::config_directory}/cruise-config.xml |tail -1 | grep -qs agentAutoRegisterKey && sed '3s|agentAutoRegisterKey=\"[0-9a-zA-Z]*\"|agentAutoRegisterKey=\"${::go::server::autoregister_key}\"|' ${::go::server::config_directory}/cruise-config.xml || sed -i '3s|\\(.*\\) />|\\1 agentAutoRegisterKey=\"${::go::server::autoregister_key}\" />|' ${::go::server::config_directory}/cruise-config.xml",
      unless  => "head -3 ${::go::server::config_directory}/cruise-config.xml| tail -1 |grep -s agentAutoRegisterKey",
      path    => ['/bin', '/usr/bin']
    }
  }

}
