# == Class: role_ccw::build
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::build (
  $builduser                  = 'rsync',
  $buildkey                   = undef,
  $builddirectory             = '/opt/build',
  $buildhost                  = 'ssh-rsa',
){

  file { $builddirectory: 
    ensure        => directory
  }

  file { "${builddirectory}/${builduser}.key":
    content       => $buildkey,
    mode          => '0700',
    owner         => 'root',
    require       => File[$builddirectory]
  }
  

  file { "${builddirectory}/buildscript.sh":
    content       => template('role_ccw/buildscript.sh.erb'),
    mode          => '0700',
    owner         => 'root',
    require       => File[$builddirectory]
  }



}
