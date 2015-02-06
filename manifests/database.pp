# == Class: linnaeusng::database
#
# database.pp for linnaeusng puppet module
#
# Author : Hugo van Duijn
#
class role_ccw::database (
  $dbName,
  $dbUser,
  $dbPassword,
  $mysqlRootPassword,
  $configuredb,
) {

  class { 'mysql::server':
    root_password    => $mysqlRootPassword
  }

  if ($configuredb == true) {
    mysql::db { $dbName:
      user           => $dbUser,
      password       => $dbPassword,
      host           => 'localhost',
      grant          => ['ALL'],
    }
  }
}
