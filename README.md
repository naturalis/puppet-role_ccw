puppet-role_ccw
===================

Puppet role definition for deployment of ccw staging and production servers

Parameters
-------------
Sensible defaults for Naturalis in init.pp.



Classes
-------------
- role_ccw
- role_ccw::staging
- role_ccw::build
- role_ccw::repo
- role_ccw::database
- role_ccw::sftpusers


Dependencies
-------------
- puppetlabs/mysql
- puppetlabs/apache2
- thias/php


Puppet code
```
class { role_ccw: }
```
Result
-------------
When staging = true: 
CCW Staging server, CCW server with staging directory and SFTP access to directories.

When build = true
CCW server with build script which will transfer database and data from staging server. 

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.


The module has been tested on:
- Ubuntu 14.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

