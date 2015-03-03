# == Class: role_ccw::build
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::build (){

# Configure Rsync/Build user
  user { $role_ccw::staginguser :
    ensure      => present,
    groups      => $role_ccw::staginguser,
    shell       => '/bin/sh',
    comment     => $role_ccw::staginguser,
    require     => Group[$role_ccw::staginguser],
  }

# create staginguser group
  group { $role_ccw::staginguser :
    ensure        => present,
  }

# create builddirectory
  file { $role_ccw::builddirectory:
    ensure        => directory
  }

# create private key for rsync ssh connectivity to staging server
  file { "${role_ccw::builddirectory}/${role_ccw::staginguser}.key":
    content       => $role_ccw::staginguserprivkey,
    mode          => '0700',
    owner         => 'root',
    require       => File[$role_ccw::builddirectory]
  }

# set local variable for buildscript.sh.erb template
  $stagingserver              = $role_ccw::stagingserver
  $builddirectory             = $role_ccw::builddirectory
  $staginguser                = $role_ccw::staginguser
  $docroot                    = $role_ccw::docroot
  $stagingdir                 = $role_ccw::stagingdir
  $mysqlRootPassword          = $role_ccw::mysqlRootPassword
  $dbName                     = $role_ccw::dbName
  $dbUser                     = $role_ccw::dbUser
  $dbPassword                 = $role_ccw::dbPassword

# create buildscript from template
  file { "${role_ccw::builddirectory}/buildscript.sh":
    content       => template('role_ccw/buildscript.sh.erb'),
    mode          => '0700',
    owner         => 'root',
    notify        => Exec['runbuild'],
    audit         => mtime,
    require       => File[$role_ccw::builddirectory]
  }

# Run Buildscript but don't stay up for the results
# With immense timeout setting of 4 hours since the buildscript may take some time.
  exec { 'runbuild':
    path          => ['/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin','/bin'],
    refreshonly   => true,
    command       => "${role_ccw::builddirectory}/buildscript.sh",
    timeout       => 14400
  }

}
