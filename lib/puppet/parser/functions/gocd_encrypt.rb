module Puppet::Parser::Functions
  newfunction(:gocd_encrypt, :type => :rvalue, :doc => <<-EOS
Encrypts data according to https://github.com/gocd/gocd/blob/b9741c2e994d09b65debe5d836aa428fd928e6db/config/config-api/src/com/thoughtworks/go/security/GoCipher.java

Usage:
  $encrypted_string = gocd_encrypt('cipher-key', 'cleartext-password')

Note, this current shells out to openssl which must be installed on the machine compiling the catalog.
Also both cleartext password and cipher key will be echoed in the process list.

  EOS
  ) do |arguments|
    raise(Puppet::ParseError, "gocd_encrypt(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size != 2
    cipher_key = arguments[0].strip
    cleartext_password = arguments[1].strip
    raise(Puppet::ParseError, "gocd_encrypt(): Cipher key cannot be empty") if cipher_key.length == 0
    raise(Puppet::ParseError, "gocd_encrypt(): Password cannot be empty") if cleartext_password.length == 0

    # a pure ruby implementation of this would be nicer..
    encrypted_text = `echo '#{cleartext_password}' | xargs echo -n | openssl enc -des-ede3-cbc -e -K '#{cipher_key}' -iv '' -a`.strip
    if $?.exitstatus != 0
      raise(Puppet::ParseError, "openssl command failed to execute")
    end
    encrypted_text
  end
end
