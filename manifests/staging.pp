# == Class: role_ccw::staging
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::staging (
  $rsyncuser                  = 'rsync',
  $rsyncuserkey               = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCaNpPzWph56gaxhHmimfhQBygiQfM5FAwnCUnIDm3wf9bfGclSd7BbuGSiduoOav5ATCkWPfow3jyLMMEkRr2SyJvHFr6SIIdjVV3ygZ8er7IhutAE78cIdIQVZ0bFBdAp/r8TFCjhw5Gi4Y3u+1PxNfgfmdpnKWAvjAAuOJQ4JJ+JPdwT7lnyLP39Q/3jLBIuzju+yNXTH/UCjl4lWwKmTRAC0HeW1s78kYyHCrhihECSGnuptqRukkEQuvUZupG/u+0HaO548VXn6uNUhiN9t7mPJ3c8aM0hbCrPAK6kKBk4l0eAd3CpHWIly5et/yZEmaze8+yv3d8OghhmBSfJ',
  $rsyncuserkeytype           = 'ssh-rsa',
  $rsyncuserkeycomment        = 'rsyncuser',
  $stagingdir                 = '/opt/ccw',
  $rwwebdirs                  = ['/var/www/htdocs/documents','/var/www/htdocs/thumbnails']
){

  
# Configure Rsync user
 user { $rsyncuser :
    ensure      => present,
    groups      => $rsyncuser,
    shell       => '/bin/sh',
    comment     => $rsyncusercomment,
    require     => Group[$rsyncuser],
  }

  group { $rsyncuser :
    ensure => present,
  }

  file { $stagingdir:
    ensure         => 'directory',
    mode           => '0750',
    owner          => $rsyncuser,
    group          => $rsyncuser,
  }

  file { "${stagingdir}/db":
    ensure         => 'directory',
    mode           => '0750',
    owner          => $rsyncuser,
    group          => $rsyncuser,
    require        => File[$stagingdir]
  }

  file { "${stagingdir}/thumbnails":
    ensure => 'link',
    target => "${role_ccw::docroot}/thumbnails",
    require => File[$rwwebdirs]
  }

  file { "${stagingdir}/documents":
    ensure => 'link',
    target => "${role_ccw::docroot}/documents",
    require => File[$rwwebdirs]

  }

  file { "/home/${rsyncuser}":
    ensure  => directory,
    owner   => $rsyncuser,
    group   => $rsyncuser,
    mode    => '0700',
  }
  
  file { "/home/${rsyncuser}/.ssh":
    ensure  => directory,
    owner   => $rsyncuser,
    group   => $rsyncuser,
    mode    => '0600',
  }
  
  file { "/home/${rsyncuser}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $rsyncuser,
    group   => $rsyncuser,
    mode    => '0600',
    require => File["/home/${rsyncuser}/.ssh"],
    }

  Ssh_authorized_key {
    require =>  File["/home/${rsyncuser}/.ssh/authorized_keys"]
  }
  
   $ssh_key_defaults = {
    ensure  => present,
    user    => $rsyncuser,
    type    => 'ssh-rsa'
  }

  ssh_authorized_key { $rsyncuserkeycomment:
    ensure  => present,
    user    => $rsyncuser,
    type    => $rsyncuserkeytype,
    key     => $rsyncuserkey,
  }
}
