# == Class: role_ccw::repo
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw::repo (
  $coderepo         = 'git@github.com:naturalis/ccw.git',
  $repoversion      = 'present',
  $reposshauth      = true,
  $repokey          = undef,
  $repokeyname      = 'githubkey',
  $repotype         = 'git',
  $repolocation     = '/var/www/htdocs',
){


# ensure git package for repo checkouts
  package { 'git':
    ensure => installed,
  }

  if ( $reposshauth == false ) {
    vcsrepo { $repolocation:
      ensure    => $repoversion,
      provider  => $repotype,
      source    => $coderepo,
      revision  => 'master',
      require   => Package['git']
    }
  } else {
    file { '/root/.ssh':
      ensure    => directory,
    }->
    file { "/root/.ssh/${repokeyname}":
      ensure    => "present",
      content   => $repokey,
      mode      => 600,
    }->
    file { '/root/.ssh/config':
      ensure    => "present",
      content   =>  template('linnaeusng/sshconfig.erb'),
      mode      => 600,
    }->
    file{ '/usr/local/sbin/known_hosts.sh' :
      ensure    => present,
      mode      => 0700,
      source    => 'puppet:///modules/linnaeusng/known_hosts.sh',
    }->
    exec{ 'add_known_hosts' :
      command   => "/usr/local/sbin/known_hosts.sh",
      path      => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      provider  => shell,
      user      => 'root',
      unless    => 'test -f /root/.ssh/known_hosts'
    }->
    file{ '/root/.ssh/known_hosts':
      mode      => 600,
    }->
    vcsrepo { $repolocation:
      ensure    => $repoversion,
      provider  => $repotype,
      source    => $coderepo,
      user      => 'root',
      revision  => 'master',
      require   => Package['git']
    }
  }
}

