# == Class: role_ccw::staging
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::staging ()
{

# import variable for usage in admin configfile
  $dbName                     = $role_ccw::dbName
  $dbUser                     = $role_ccw::dbUser
  $dbPassword                 = $role_ccw::dbPassword

# Create admin configfile from template
  file { "${role_ccw::docroot}/admin/admin_config.inc.php":
    content       => template('role_ccw/admin_config.inc.php.erb'),
    mode          => '0640',
    owner         => 'www-data',
    group         => $role_ccw::staginguser,
    require       => Class['role_ccw::repo'],
  }

# Create Staging directory
  file { $role_ccw::stagingdir:
    ensure      => 'directory',
    mode        => '0770',
    owner       => $role_ccw::staginguser,
    group       => $role_ccw::staginguser,
  }

# Create Staging db subdirectory
  file { "${role_ccw::stagingdir}/db":
    ensure      => 'directory',
    mode        => '0770',
    owner       => $role_ccw::staginguser,
    group       => $role_ccw::staginguser,
    require     => File[$role_ccw::stagingdir]
  }

# Create Staging thumbnails subdirectory
  file { "${role_ccw::stagingdir}/thumbnails":
    ensure      => 'link',
    target      => "${role_ccw::docroot}/thumbnails",
    require     => File[$role_ccw::webdirs]
  }

# Create Staging documents subdirectory
  file { "${role_ccw::stagingdir}/documents":
    ensure      => 'link',
    target      => "${role_ccw::docroot}/documents",
    require     => File[$role_ccw::webdirs]
  }

# Create Staging xml subdirectory
  file { "${role_ccw::stagingdir}/xml":
    ensure      => 'link',
    target      => "${role_ccw::docroot}/xml",
    require     => File[$role_ccw::webdirs]
  }

# create staginguser
  user { $role_ccw::staginguser :
    ensure      => present,
    groups      => $role_ccw::staginguser,
    shell       => '/bin/sh',
    comment     => $role_ccw::staginguserkeycomment,
    require     => Group[$role_ccw::staginguser],
  }

# Create rsync group
  group { $role_ccw::staginguser :
    ensure      => present,
  }

# Create rsync homedirectory
  file { "/home/${role_ccw::staginguser}":
    ensure      => directory,
    owner       => $role_ccw::staginguser,
    group       => $role_ccw::staginguser,
    mode        => '0700',
  }

# Create .ssh directory in rsync home directory
  file { "/home/${role_ccw::staginguser}/.ssh":
    ensure      => directory,
    owner       => $role_ccw::staginguser,
    group       => $role_ccw::staginguser,
    mode        => '0600',
  }

# Create authorized_keys file
  file { "/home/${role_ccw::staginguser}/.ssh/authorized_keys":
    ensure      => present,
    owner       => $role_ccw::staginguser,
    group       => $role_ccw::staginguser,
    mode        => '0600',
    require     => File["/home/${role_ccw::staginguser}/.ssh"],
    }

# create authorized key
  Ssh_authorized_key {
    require =>  File["/home/${role_ccw::staginguser}/.ssh/authorized_keys"]
  }

# set authorized key defaults
  $ssh_key_defaults = {
    ensure  => present,
    user    => $role_ccw::staginguser,
    type    => 'ssh-rsa'
  }

# fill authorized key with public rsync key
  if $role_ccw::staginguserpubkey {
    ssh_authorized_key { $role_ccw::staginguserkeycomment:
      ensure  => present,
      user    => $role_ccw::staginguser,
      type    => $role_ccw::staginguserkeytype,
      key     => $role_ccw::staginguserpubkey,
    }
  }

# create database dump when new import is finished.
# import log file is monitored, dbdump is run when
# file date changes
  file { "${role_ccw::docroot}/admin/version.txt":
    mode          => '0770',
    audit         => mtime,
    recurse       => false,
    notify        => Exec['dbdump'],
    require       => Class['mysql::server']
  }

# dbdump exec
  exec { 'dbdump':
    path          => ['/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin','/bin'],
    refreshonly   => true,
    command       => "mysqldump -u root -p${role_ccw::mysqlRootPassword} --opt --flush-logs --single-transaction --databases ${role_ccw::dbName} | gzip -c > ${role_ccw::stagingdir}/db/ccw.sql.gz",
  }

}
