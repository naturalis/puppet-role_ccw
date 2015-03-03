puppet-role_ccw
===================

Puppet role definition for deployment of ccw staging and production servers

Parameters
-------------
Sensible defaults for Naturalis in init.pp.

````
  $staginguser                = 'staging',                              ' User account on Staging server, used as main group for SFTP users and deployments
  $staginguserpubkey          = 'AAAAB3NzaC1yc2EAAAABJQAAAIEAmdU9',     ' Public key of staging user
  $staginguserprivkey         = undef,                                  ' Private key of staging user
  $staginguserkeytype         = 'ssh-rsa',                              ' Staging user ssh key type
  $staginguserkeycomment      = 'staginguser',                          ' Staging user ssh key comment
  $stagingserver              = false,                                  ' set to true if server will be a staging server
  $stagingserveraddress       = '10.42.1.200',                          ' IP address of staging server
  $stagingdir                 = '/opt/ccw',                             ' Staging directory
  $build                      = false,                                  ' set to true to deploy and run buildscript after setting up empty server
  $builddirectory             = '/opt/build',                           ' Directory where buildscript will be created
  $docroot                    = '/var/www/htdocs',                      ' docroot
  $coderepo                   = 'git@github.com:naturalis/ccw.git',     ' repo with CCW code
  $repotype                   = 'git',                                  ' repo type
  $repoversion                = 'present',                              ' Version of repo
  $repokey                    = undef,                                  ' Private key of repo for private repo. 
  $repokeyname                = 'githubkey',                            ' Key name for ssh config of root user
  $webdirs                    = ['/var/www/htdocs','/var/www/htdocs/thumbnails',        ' Web directories with specific permissions ( www-data:staginguser 2664 )
                                '/var/www/htdocs/documents','/var/www/htdocs/xml'],
  $configuredb                = false,                                  ' May be set to true if database build = false, normaly the buildscript will take care of creating the database
  $mysqlRootPassword          = 'rootpassword',                         ' Root password of Mysql installation
  $dbName                     = 'ccw',                                  ' Database name of application
  $dbUser                     = 'ccwdbuser',                            ' Database user of application
  $dbPassword                 = 'dbpassword',                           ' Database password of application
  $sftpusers                  = {'sftpuser' => {                        ' Users Hash of SFTP users which may edit specific files using SFTP
                                  'comment'         => 'Sftpuser 1',
                                  'ssh_key_type'    => 'ssh-rsa',
                                  'ssh_key_comment' => 'user1.ccw.naturalis.nl',
                                  'ssh_key'         => 'AAAAB3NzaC1yc2EAAAABJQAAAIEAmdU9//WJ4BqGWoH1TW3VmRnIcTbCaog38evKayf6hNe/jBuLRU9/MjDLsd3CfiLXVMKmMPOaGiovXQ5r4R0sSq9GknZU+SBB1oYLQUDi/+XseJG1dnTucDQ/Gz5gyV1QvWf86aaT7169qRCy7iWRIoRYaua/R3HIpWMXrNlzL/0=',
                                                },
                                },
  $instances                  = {'ccw.naturalis.nl' => {                ' Vhost Hash for apache config
                          'serveraliases'   => '*.naturalis.nl',
                          'docroot'         => '/var/www/htdocs',
                          'directories'     => [{ 'path' => '/var/www/htdocs',
                          'options' => '-Indexes +FollowSymLinks +MultiViews',
                          'allow_override' => 'All'}],
                          'port'            => 80,
                          'serveradmin'     => 'webmaster@naturalis.nl',
                          'priority'        => 10,
                          },
                        },
```


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

