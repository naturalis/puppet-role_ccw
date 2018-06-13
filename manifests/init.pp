# == Class: role_ccw
#
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_ccw (
  $compose_version            = '1.17.1',
  $repo_source                = 'https://github.com/naturalis/docker-ccw.git',
  $repo_ensure                = 'latest',  
  $coderepo                   = 'git@github.com:naturalis/ccw.git',
  $repotype                   = 'git',
  $repoversion                = 'present',
  $repokey                    = undef,
  $repokeyname                = 'githubkey',
  $mysql_root_password        = 'rootpassword',
  $mysql_host                 = 'db',
  $mysql_db                   = 'ccw',
  $mysql_user                 = 'ccwdbuser',
  $mysql_password             = 'dbpassword',
  $ccw_url                    = 'ccw.naturalis.nl',
  $minio_url                  = 'ccw-storage.naturalis.nl',
  $minio_access_key           = '12345',
  $minio_secret_key           = '12345678',
  $adminpageuser              = '12345',
  $adminpagepassword          = '12345678',
  $repo_dir                   = '/opt/docker-ccw',
  $docroot                    = '/data/ccw/www',
  $traefik_toml_file          = '/opt/traefik/traefik.toml',
  $traefik_acme_json          = '/opt/traefik/acme.json',
){

# Get code from repository
  class { 'role_ccw::repo':  }

# Create configfile from template
  file { "${docroot}/includes/config.inc.php":
    content       => template('role_ccw/config.inc.php.erb'),
    mode          => '0644',
    require       => Class['role_ccw::repo'],
  }

# Create htaccess / htpasswd in admin folder
  ensure_packages(['apache2-utils','git'])

# Create htaccess / htpasswd in admin folder
  role_ccw::htpasswd {$role_ccw::adminpageuser:
    password        => $role_ccw::adminpagepassword,
    location        => "${role_ccw::docroot}/admin",
    require         => [Package['apache2-utils'],Class[Role_ccw::Repo]]
  }

# Create admin configfile from template
  file { "${role_ccw::docroot}/admin/admin_config.inc.php":
    content       => template('role_ccw/admin_config.inc.php.erb'),
    mode          => '0644',
    require       => Class['role_ccw::repo'],
  }


  file { '/data/ccw/initdb/1_init_db.sql':
    ensure   => file,
    mode     => '0644',
    content  => template('role_ccw/1_init_db.erb'),
    require  => File['/data/ccw/initdb'],
  }

  file { '/data/ccw/mysqlconf/my-ccw.cnf':
    ensure   => file,
    mode     => '0644',
    source    => 'puppet:///modules/role_ccw/my-ccw.cnf',
    require  => File['/data/ccw/mysqlconf'],
  }

  include 'docker'
  include 'stdlib'

  Exec {
    path => '/usr/local/bin/',
    cwd  => $role_ccw::repo_dir,
  }

  file { ['/data','/data/ccw','/data/ccw/initdb','/data/ccw/mysqlconf','/data/ccw/traefik', '/opt/traefik', $role_ccw::repo_dir] :
    ensure   => directory,
  }

  file { "${role_ccw::repo_dir}/.env":
    ensure   => file,
    mode     => '0600',
    content  => template('role_ccw/env.erb'),
    require  => Vcsrepo[$role_ccw::repo_dir],
    notify   => Exec['Restart containers on change'],
  }

  class {'docker::compose': 
    ensure      => present,
    version     => $role_ccw::compose_version,
    notify      => Exec['apt_update']
  }

  docker_network { 'web':
    ensure   => present,
  }

  ensure_packages(['git','python3'], { ensure => 'present' })

  vcsrepo { $role_ccw::repo_dir:
    ensure    => $role_ccw::repo_ensure,
    source    => $role_ccw::repo_source,
    provider  => 'git',
    user      => 'root',
    revision  => 'master',
    require   => [Package['git'],File[$role_ccw::repo_dir]]
  }

  file { $traefik_toml_file :
    ensure   => file,
    content  => template('role_ccw/traefik.toml.erb'),
    require  => File['/opt/traefik'],
    notify   => Exec['Restart containers on change'],
  }

  file { $traefik_acme_json :
    ensure   => present,
    mode     => '0600',
    require  => File['/opt/traefik'],
    notify   => Exec['Restart containers on change'],
  }


  docker_compose { "${role_ccw::repo_dir}/docker-compose.yml":
    ensure      => present,
    require     => [
      Vcsrepo[$role_ccw::repo_dir],
      File["${role_ccw::repo_dir}/.env"],
      File['/data/ccw/initdb/1_init_db.sql'],
      Docker_network['web'],
    ]
  }

  exec { 'Pull containers' :
    command  => 'docker-compose pull',
    schedule => 'everyday',
  }

  exec { 'Up the containers to resolve updates' :
    command  => 'docker-compose up -d',
    schedule => 'everyday',
    require  => Exec['Pull containers']
  }

  exec {'Restart containers on change':
    refreshonly => true,
    command     => 'docker-compose up -d',
    require     => Docker_compose["${role_ccw::repo_dir}/docker-compose.yml"]
  }

  # deze gaat per dag 1 keer checken
  # je kan ook een range aan geven, bv tussen 7 en 9 's ochtends
  schedule { 'everyday':
     period  => daily,
     repeat  => 1,
     range => '5-7',
  }

}
