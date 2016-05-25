# == Define: go::server::local_account
#
# Creates a local go user in the configured password file
#
# === Parameters:
#
# [*namevar*]
#   No use currently, must be unique
#
# [*username*]
#   Username of user
#   Valid values: string
#
# [*password*]
#   Cleartext password of user
#   Valid values: string
#
# === Example:
#
# go::server::local_account { 'my_account':
#   username => 'foo',
#   password => 'bar',
# }
#
define go::server::local_account (
  $username,
  $password,
) {

  validate_string($username)
  validate_string($password)

  $password_hash = gocd_password_hash($password)
  $content_string = "${username}:${password_hash}\n"

  @concat::fragment { "go_password_file_user: ${username}":
    target  => $::go::server::file::local_password_file,
    content => $content_string,
    order   => '01',
  }

}
