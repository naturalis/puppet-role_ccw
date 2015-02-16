# == Class: role_ccw::repo
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::repo ()
{

# ensure git package for repo checkouts
  package { 'git':
    ensure => installed,
  }

# set local variable for template sshconfig.erb
$repokeyname = $role_ccw::repokeyname

# Create /root/.ssh directory
  file { '/root/.ssh':
    ensure    => directory,
  }->
# Create /root/.ssh/repokeyname file
  file { "/root/.ssh/${role_ccw::repokeyname}":
    ensure    => "present",
    content   => $role_ccw::repokey,
    mode      => 600,
  }->
# Create sshconfig file 
  file { '/root/.ssh/config':
    ensure    => "present",
    content   =>  template('role_ccw/sshconfig.erb'),
    mode      => 600,
  }->
# copy known_hosts.sh file from puppet module
  file{ '/usr/local/sbin/known_hosts.sh' :
    ensure    => present,
    mode      => 0700,
    source    => 'puppet:///modules/role_ccw/known_hosts.sh',
  }->
# run known_hosts.sh for future acceptance of github key
  exec{ 'add_known_hosts' :
    command   => "/usr/local/sbin/known_hosts.sh",
    path      => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
    provider  => shell,
    user      => 'root',
    unless    => 'test -f /root/.ssh/known_hosts'
  }->
# give known_hosts file the correct permissions
  file{ '/root/.ssh/known_hosts':
    mode      => 600,
  }->
# checkout using vcsrepo 
  vcsrepo { $role_ccw::docroot:
    ensure    => $role_ccw::repoversion,
    provider  => $role_ccw::repotype,
    source    => $role_ccw::coderepo,
    user      => 'root',
    revision  => 'master',
    require   => Package['git']
  }
}

