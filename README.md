# go

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with go](#setup)
    * [What go affects](#what-go-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with go](#beginning-with-go)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the life cycle of the continous delivery platform Go
provided by Thoughtworks. It aims to be self contained and only focuses
on managing the core functionality of Go. Tested on Redhat OS family

## Module Description

Scope of the functionality provided by this module

* Server
  * Manage daemon user
  * Manage yum repository
  * Manage package installation
  * Manage service state
  * Manage Go configuration directives such as heap allocation, path to lib and log directories


## Setup

### What go affects

* Server
  * User and group 'go'
  * (if osfamily redhat) yum repository Thoughtworks
  * Package go-server
  * Service go-server
  * Warning: force mode will destroy all resources managed by Go when setting ensure => absent

### Setup Requirements **OPTIONAL**

No requirements apart from dependencies specified in metadata.json

### Beginning with go

Checkout the module to your puppet modules folder including dependencies or use librarian-puppet to take care that.

## Usage

Puppet classes and defines exposed to the end user.

* Server
  * Class go::server

The go module is contained using the anchor pattern, so you should be
able to form reliable dependencies to class go::server for example.

## Reference

See the code

## Limitations

Supported on osfamily Redhat, not tested on osfamily Debian

## Development

"Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are."

TBD

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
