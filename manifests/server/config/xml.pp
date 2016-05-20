# == Class: go::server::config::xml
#
# Manages certain elements of the cruise-config.xml via augeas and the xml lense
#
class go::server::config::xml (
  $autoregister          = $::go::server::autoregister,
  $autoregister_key      = $::go::server::autoregister_key,
  $local_auth_enable     = $::go::server::local_auth_enable,
  $password_file         = $::go::server::local_password_file,
  $ldap_auth_enable      = $::go::server::ldap_auth_enable,
  $ldap_uri              = $::go::server::ldap_uri,
  $ldap_manager_dn       = $::go::server::ldap_manager_dn,
  $ldap_manager_password = $::go::server::ldap_manager_password,
  $ldap_search_filter    = $::go::server::ldap_search_filter,
  $ldap_base_dn          = $::go::server::ldap_base_dn,
) {

  include ::go::server::config::xml::dependencies

  if $autoregister {
    validate_re($autoregister_key, '[0-9a-zA-Z]', "Invalid parameter autoregister_key value ${autoregister_key}. Must be alphanumerical")

    augeas { 'set_cruise_autoregister':
      incl    => "${::go::server::config_directory}/cruise-config.xml",
      lens    => 'Xml.lns',
      context => "/files${::go::server::config_directory}/cruise-config.xml/cruise/server/#attribute",
      changes => "set agentAutoRegisterKey ${autoregister_key}",
    }
  }

  if $local_auth_enable {
    augeas { 'set_password_file_authentication':
      incl    => "${::go::server::config_directory}/cruise-config.xml",
      lens    => 'Xml.lns',
      context => "/files${::go::server::config_directory}/cruise-config.xml/cruise",
      changes => [
        'set server ""',
        'set server/security ""',
        'set server/security/passwordFile #empty',
        "set server/security/passwordFile/#attribute/path ${password_file}",
      ],
    }
  }

  if $ldap_auth_enable {
    validate_re($ldap_uri, '^(l|L)(d|D)(a|A)(p|P)(s|S)?://.*', "Parameter ldap_uri is not containing a valid ldap uri")
    validate_string($ldap_manager_dn)
    validate_string($ldap_manager_password)
    validate_string($ldap_search_filter)
    validate_string($ldap_base_dn)
    $ldap_manager_password_encrypted = gocd_encrypt($::go::server::encryption_cipher, $ldap_manager_password)
    augeas { 'set_ldap_authentication':
      incl    => "${::go::server::config_directory}/cruise-config.xml",
      lens    => 'Xml.lns',
      context => "/files${::go::server::config_directory}/cruise-config.xml/cruise",
      changes => [
        'set server ""',
        'set server/security ""',
        'set server/security/ldap ""',
        "set server/security/ldap/#attribute/uri ${ldap_uri}",
        "set server/security/ldap/#attribute/managerDn ${ldap_manager_dn}",
        "set server/security/ldap/#attribute/encryptedManagerPassword ${ldap_manager_password_encrypted}",
        "set server/security/ldap/#attribute/searchFilter ${ldap_search_filter}",
        'set server/security/ldap/bases ""',
        'set server/security/ldap/bases/base #empty',
        "set server/security/ldap/bases/base/#attribute/value ${ldap_base_dn}",
      ],
    }
  }

}
