# == Class: role_ccw::database
#
# database.pp for role_ccw puppet module
#
# Author : Hugo van Duijn
#
class role_ccw::database ()
{

# Install mysql server and set root password
  class { 'mysql::server':
    root_password    => $role_ccw::mysqlRootPassword
  }

# copy known_hosts.sh file from puppet module
  file{ '/opt/ccw.sql' :
    ensure    => present,
    mode      => '0700',
    source    => 'puppet:///modules/role_ccw/ccw.sql',
  }

# Add database + user
# this is disabled by default since the buildscript should take care of this.
  if ($role_ccw::configuredb == true) or ($role_ccw::stagingserver == true) {
    mysql::db { $role_ccw::dbName:
      user           => $role_ccw::dbUser,
      password       => $role_ccw::dbPassword,
      host           => 'localhost',
      grant          => ['ALL'],
      sql            => '/opt/ccw.sql',
      import_timeout => 900
    }
  }
}
