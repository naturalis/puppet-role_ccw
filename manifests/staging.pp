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
# Create Staging directory
  file { $role_ccw::stagingdir:
    ensure      => 'directory',
    mode        => '0770',
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
  }

# Create Staging db subdirectory
  file { "${role_ccw::stagingdir}/db":
    ensure      => 'directory',
    mode        => '0770',
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
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
    ensure      => 'directory',
    require     => File[$role_ccw::stagingdir],
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
    mode        => '0770'
  }

# create rsyncuser
 user { $role_ccw::rsyncuser :
    ensure      => present,
    groups      => $role_ccw::rsyncuser,
    shell       => '/bin/sh',
    comment     => $role_ccw::rsyncusercomment,
    require     => Group[$role_ccw::rsyncuser],
  }

# Create rsync group
  group { $role_ccw::rsyncuser :
    ensure      => present,
  }

# Create rsync homedirectory
  file { "/home/${role_ccw::rsyncuser}":
    ensure      => directory,
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
    mode        => '0700',
  }
  
# Create .ssh directory in rsync home directory
  file { "/home/${role_ccw::rsyncuser}/.ssh":
    ensure      => directory,
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
    mode        => '0600',
  }
  
# Create authorized_keys file
  file { "/home/${role_ccw::rsyncuser}/.ssh/authorized_keys":
    ensure      => present,
    owner       => $role_ccw::rsyncuser,
    group       => $role_ccw::rsyncuser,
    mode        => '0600',
    require     => File["/home/${role_ccw::rsyncuser}/.ssh"],
    }

# create authorized key
  Ssh_authorized_key {
    require =>  File["/home/${role_ccw::rsyncuser}/.ssh/authorized_keys"]
  }

# set authorized key defaults    
  $ssh_key_defaults = {
    ensure  => present,
    user    => $role_ccw::rsyncuser,
    type    => 'ssh-rsa'
  }
  
# fill authorized key with public rsync key
  if $role_ccw::rsyncuserkey {
    ssh_authorized_key { $role_ccw::rsyncuserkeycomment:
      ensure  => present,
      user    => $role_ccw::rsyncuser,
      type    => $role_ccw::rsyncuserkeytype,
      key     => $role_ccw::rsyncuserkey,
    }
  }

}
