require 'base64'
require 'digest/sha1'

module Puppet::Parser::Functions
  newfunction(:gocd_password_hash, :type => :rvalue, :doc => <<-EOS
Hashes password according to https://docs.go.cd/current/configuration/dev_authentication.html#file-based-authentication

Usage:
  $hashed_string = gocd_password_hash('cleartext-password')

  EOS
  ) do |arguments|
    raise(Puppet::ParseError, "gocd_password_hash(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
    cleartext = arguments[0].to_s.strip
    raise(Puppet::ParseError, "gocd_password_hash(): Password cannot be empty") if cleartext.length == 0
    Base64.encode64(Digest::SHA1.digest(cleartext)).strip
  end
end
