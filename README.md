# go

[![Build Status](https://secure.travis-ci.org/unibet/puppet-go.png)](http://travis-ci.org/unibet/puppet-go)
[![Puppet Forge](https://img.shields.io/puppetforge/v/unibet/go.svg)](https://forge.puppetlabs.com/unibet/go)
[![Puppet Forge](https://img.shields.io/puppetforge/f/unibet/go.svg)](https://forge.puppetlabs.com/unibet/go)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with go](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with go](#beginning-with-go)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The go module manages the life cycle of the continuous delivery platform Go
provided by Thoughtworks. It aims for self containment and only focus on solving tasks surrounding the Go product with minimal external dependencies.

## Module Description

Thoughtworks Go is a continuous delivery platform used for build, packaging and orchestrating application deployments. Go uses a server component for the administration, presentation and scheduling part, and an agent component responsible for carrying out the work. The Go module manages these concerns within separate named spaced classes.

## Setup

### Setup Requirements

Go depends on JDK to be installed in order to run. This dependency must be managed outside of the Go module.
See: http://www.thoughtworks.com/products/docs/go/current/help/system_requirements.html

In addition, the Go module depends on functions and resource types provided by the puppetlabs-stdlib module and the puppetlabs-concat module.

### Beginning with go

#### Server
```
class { '::go::server':
	manage_package_repo => true
}
```

#### Agent
```
class { '::go::agent':
	manage_package_repo	=> true
} ->
::go::agent::instance { 'agent1':
	path 			=> '/opt/go',
	go_server_host	=> 'localhost',
	go_server_port	=> 8153
}
```
## Usage

The Go module exposes the following classes

* go::agent
* go::server

It also exposes these defined types:

* go::agent::instance
* go::server::local_account

The exposed classes are contained using the anchor pattern provided via puppetlabs-stdlib, thus you should be able to form reliable dependencies on these classes as expect all of its resources to be realized.

## Reference

See the code

## Limitations

Tested and used on Redhat and Ubuntu. See metadata.json for supported OS combinations.

## Development

* Install development dependencies

```
$ bundle install
```

* Make changes
* Run tests

```
$ bundle exec rake validate
$ bundle exec rake spec
```

* Commit to feature branch and create pull request
