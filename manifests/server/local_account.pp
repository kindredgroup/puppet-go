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

  # this alg seem to generate acceptable go password hashes
  # https://docs.go.cd/current/configuration/dev_authentication.html#file-based-authentication
  $password_hash = inline_template("<%- require 'base64'; require 'digest/sha1'; -%><%= Base64.encode64(Digest::SHA1.digest(@password)) %>")
  $content_string = "${username}:${password_hash}"

  @concat::fragment { "go_password_file_user: ${username}":
    target  => $::go::server::file::local_password_file,
    content => $content_string,
    order   => '01',
  }

}
