# == Class: role_ccw::sftpusers
#
#Installs users and ssh keys from user array
#
#
define role_ccw::sftpusers(
  $username         = $title,
  $comment          = 'comment',
  $ssh_key          = '',
  $ssh_key_comment  = '',
  $ssh_key_type     = '',
) {

# Create user and set rsync group as default group
  user { $username :
    ensure      => present,
    groups      => $role_ccw::staginguser,
    gid         => $role_ccw::staginguser,
    shell       => '/bin/zsh',
    comment     => $comment,
  }

# Create user group
  group { $username :
    ensure      => present,
  }

# Create homedirectory
  file { "/home/${username}":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => '0700',
    require => Group[$username]
  }

# Create .ssh directory in homedirectory
  file { "/home/${username}/.ssh":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => '0600',
    require => File["/home/${username}"],
  }

# Create .zshrc file in homedirectory with default umask of 002.
# new files are not only readable but also writable by the
# rsync group this way
  file { "/home/${username}/.zshrc":
    owner   => $username,
    group   => $username,
    content => 'umask 002
',
    mode    => '0640',
    require => File["/home/${username}"],
  }

# Create SSH authorized key
  file { "/home/${username}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $username,
    group   => $username,
    mode    => '0600',
    require => File["/home/${username}/.ssh"],
    }

# Initialize SSH authorized key
  Ssh_authorized_key {
    require =>  File["/home/${username}/.ssh/authorized_keys"]
  }

# Set SSH key defaults
  $ssh_key_defaults = {
    ensure  => present,
    user    => $username,
    type    => 'ssh-rsa'
  }

# fill authorized key with public ssh key
  if $ssh_key {
    ssh_authorized_key { $ssh_key_comment:
      ensure  => present,
      user    => $username,
      type    => $ssh_key_type,
      key     => $ssh_key,
    }
  }

# Create symlink in homedirectory to staging directory for access to content
  file { "/home/${username}/ccw":
    ensure  => 'link',
    target  => $role_ccw::stagingdir,
    require => File["/home/${username}"]
  }



}
