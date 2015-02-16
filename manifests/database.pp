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

# Add database + user
# this is disabled by default since the buildscript should take care of this.
  if ($role_ccw::configuredb == true) {
    mysql::db { $role_ccw::dbName:
      user           => $role_ccw::dbUser,
      password       => $role_ccw::dbPassword,
      host           => 'localhost',
      grant          => ['ALL'],
    }
  }
}
