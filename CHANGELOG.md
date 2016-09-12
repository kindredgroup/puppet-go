## Release 0.4.1
### Summary

Fix release for https://github.com/unibet/puppet-go/issues/8

## Release 0.4.0
### Summary

First version using the changelog

- Adds custom fact gocd_installed
- Prevents service restart during initial install as it can corrupt go server state files created on first startup, the RPM provided by Thoughtworks has a post install script that starts go-server and this is a hack to circumvent the issues with this.
- Adds healthcheck script and class go::server::wait_for_service to allow go server to be properly initialized before making cruise config changes
- Allows management of go server encryption cipher
- Uses augeas to configure autoregister key in go server cruise-config.xml rather than using sed
- Uses augeas to configure local password file auth and ldap auth in cruise-config.xml
