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
  $rsyncuserkey               = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCaNpPzWph56gaxhH\
mimfhQBygiQfM5FAwnCUnIDm3wf9bfGclSd7BbuGSiduoOav5ATCkWPfow3jyLMMEkRr2SyJvHFr6SI\
IdjVV3ygZ8er7IhutAE78cIdIQVZ0bFBdAp/r8TFCjhw5Gi4Y3u+1PxNfgfmdpnKWAvjAAuOJQ4JJ+J\
PdwT7lnyLP39Q/3jLBIuzju+yNXTH/UCjl4lWwKmTRAC0HeW1s78kYyHCrhihECSGnuptqRukkEQuvU\
ZupG/u+0HaO548VXn6uNUhiN9t7mPJ3c8aM0hbCrPAK6kKBk4l0eAd3CpHWIly5et/yZEmaze8+yv3d\
8OghhmBSfJ',
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
  $stagingdir                 = '/opt/ccw',
  $webdirs                    = ['/var/www/htdocs','/var/www/htdocs/thumbnails',
                                '/var/www/htdocs/documents'],
  $configuredb                = false,
  $mysqlRootPassword          = 'rootpassword',
  $dbName                     = 'ccw',
  $dbUser                     = 'ccwdbuser',
  $dbPassword                 = 'dbpassword',
  $sftpusers                  = {'sftpuser' => {
                                  'comment'         => 'Sftpuser 1',
                                  'shell'           => '/bin/zsh',
                                  'ssh_key_type'    => 'ssh-rsa',
                                  'ssh_key_comment' => 'user1.ccw.naturalis.nl',
                                  'ssh_key'         => 'AAAAB3NzaC1yc2EAAAABJQA\
AAIEAmdU9//WJ4BqGWoH1TW3VmRnIcTbCaog38evKayf6hNe/jBuLRU9/MjDLsd3CfiLXVMKmMPOaGi\
ovXQ5r4R0sSq9GknZU+SBB1oYLQUDi/+XseJG1dnTucDQ/Gz5gyV1QvWf86aaT7169qRCy7iWRIoRYa\
ua/R3HIpWMXrNlzL/0=',
                                                },
                                },
  $instances                  = {'ccw.naturalis.nl' => {
                          'serveraliases'   => '*.naturalis.nl',
                          'docroot'         => '/var/www/htdocs',
                          'directories'     => [{ 'path' => '/var/www/htdocs',
                          'options' => '-Indexes +FollowSymLinks +MultiViews',
                          'allow_override' => 'All'}],
                          'port'            => 80,
                          'serveradmin'     => 'webmaster@naturalis.nl',
                          'priority'        => 10,
                          },
                        },
){

  file { $webdirs:
    ensure         => 'directory',
    mode           => '0770',
    owner          => 'www-data',
    group          => $rsyncuser,
    require        => Class['apache']
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

# Create Apache Vitual host
  create_resources('apache::vhost', $instances)

# Configure MySQL
  class { 'role_ccw::database':  }

# Get code from repository
  class { 'role_ccw::repo':  }

# Create configfile from template
  file { "${docroot}/includes/config.inc.php":
    content       => template('role_ccw/config.inc.php.erb'),
    mode          => '0640',
    owner         => 'www-data',
    group         => $rsyncuser,
    require       => Class['role_ccw::repo'],
  }

# include staging server code when stagingserver is true
# add sftpusers and include staging.pp
  if ($stagingserver == true) {
    if $sftpusers {
      create_resources('role_ccw::sftpusers', $sftpusers)
    }
    class { 'role_ccw::staging': }
  }

# run build script when build = true
  if ($build == true) {
    class { 'role_ccw::build': }
  }

}
