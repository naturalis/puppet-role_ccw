# == Class: role_ccw
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw (
  $rsyncuser                  = 'rsync',
  $rsyncuserkey               = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCaNpPzWph56gaxhHmimfhQBygiQfM5FAwnCUnIDm3wf9bfGclSd7BbuGSiduoOav5ATCkWPfow3jyLMMEkRr2SyJvHFr6SIIdjVV3ygZ8er7IhutAE78cIdIQVZ0bFBdAp/r8TFCjhw5Gi4Y3u+1PxNfgfmdpnKWAvjAAuOJQ4JJ+JPdwT7lnyLP39Q/3jLBIuzju+yNXTH/UCjl4lWwKmTRAC0HeW1s78kYyHCrhihECSGnuptqRukkEQuvUZupG/u+0HaO548VXn6uNUhiN9t7mPJ3c8aM0hbCrPAK6kKBk4l0eAd3CpHWIly5et/yZEmaze8+yv3d8OghhmBSfJ',
  $rsyncuserkeytype           = 'ssh-rsa',
  $rsyncuserkeycomment        = 'rsyncuser',
  $stagingserver              = undef,
  $build                      = undef,
  $buildhost                  = '10.42.1.200',
  $buildkey                   = undef,
  $builddirectory             = '/opt/build',
  $builduser                  = 'rsync',
  $docroot                    = '/var/www/htdocs',
  $coderepo                   = 'git@github.com:naturalis/ccw.git',
  $repotype                   = 'git',
  $repoversion                = 'present',
  $repokey                    = undef,
  $repokeyname                = 'githubkey',
  $reposshauth                = true,
  $webdirs                    = ['/var/www/htdocs'],
  $rwwebdirs                  = ['/var/www/htdocs/cache'],
  $configuredb                = true,
  $mysqlRootPassword          = 'rootpassword',
  $dbName                     = 'ccw',
  $dbUser                     = 'ccwdbuser',
  $dbPassword                 = 'dbpassword',
  $instances                  = {'site.lampsite.nl' => {
                           'serveraliases'   => '*.lampsite.nl',
                           'docroot'         => '/var/www/htdocs',
                           'directories'     => [{ 'path' => '/var/www/htdocs', 'options' => '-Indexes +FollowSymLinks +MultiViews', 'allow_override' => 'All' }],
                           'port'            => 80,
                           'serveradmin'     => 'webmaster@naturalis.nl',
                           'priority'        => 10,
                          },
                         },
){

    file { $webdirs:
      ensure         => 'directory',
      mode           => '0750',
      owner          => 'root',
      group          => 'www-data',
      require        => Class['apache']
    }->
    file { $rwwebdirs:
      ensure         => 'directory',
      mode           => '0777',
      owner          => 'www-data',
      group          => 'www-data',
      require        => File[$webdirs]
    }
  

# install php module php-gd
  php::module { [ 'gd','mysql','curl' ]: }

# Install apache and enable modules
  class { 'apache':
    default_mods     => true,
    mpm_module       => 'prefork',
  }
  include apache::mod::php
  include apache::mod::rewrite
  include apache::mod::speling

# Create instances (vhosts)
  class { 'role_lamp::instances': 
      instances      => $instances,
  }

# Configure MySQL 
  class { 'role_ccw::database':
    dbUser              => $dbUser,
    dbPassword          => $dbPassword,
    dbName              => $dbName,
    mysqlRootPassword   => $mysqlRootPassword,
    configuredb         => $configuredb,
  }


# Get code from repository
  class { 'role_ccw::repo':
    repolocation  => $coderoot,
    coderepo      => $coderepo,
    repoversion   => $repoversion,
    reposshauth   => $reposshauth,
    repokey       => $repokey,
    repokeyname   => $repokeyname,
    repotype      => $repotype,
  }

  file { "${docroot}/includes/config.inc.php":
    content       => template('role_ccw/config.inc.php.erb'),
    mode          => '0640',
    owner         => 'root',
    group         => $apachegroup,
    require       => Class['role_ccw::repo'],
  }

# include staging server code when true
  if ($stagingserver == 'true') {
    class { 'role_ccw::staging':
      rsyncuser           => $rsyncuser,
      rsyncuserkey        => $rsyncuserkey,
      rsyncuserkeytype    => $rsyncuserkeytype,
      rsyncuserkeycomment => $rsyncuserkeycomment,
    }
  }

# run build script when build = true
  if ($build == 'true') {
    class { 'role_ccw::build':
      builddirectory      => $builddirectory,
      buildhost           => $buildhost,
      buildkey            => $buildkey,
      builduser           => $builduser,
    }
  }

  
}
