puppet-role_ccw
===================

Puppet role definition for deployment of ccw staging and production servers

Parameters
-------------
Sensible defaults for Naturalis in init.pp.

```
  instances            = Instance hash, see the default for parameters
```


Classes
-------------
- role_ccw
- role_ccw::staging


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



Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.


The module has been tested on:
- Ubuntu 14.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

