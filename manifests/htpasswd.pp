# == Define: role_ccw::htpasswd
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
define role_ccw::htpasswd(
  $password     = 'password',
  $location     = '/var/www/htdocs/admin',
  $encryption   = md5
)
{

# Set path for exec
  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

# Create /opt/htpasswd directory
  file { '/opt/htpasswd':
    ensure  => directory
  }

# Create .htpasswd file
  role_ccw::htpasswdfile{ $name:
    file        => '/opt/htpasswd/.htpasswd',
    require     => File['/opt/htpasswd']
  }

# Select encryption parameter
  case $encryption {
    md5:        {   $enctype = '-m' }
    sha:        {   $enctype = '-s' }
    crypt:      {   $enctype = '-d' }
    plain:      {   $enctype = '-p' }
    default:    {   $enctype = '-m' }
  }

# Define exec statement
  $cmd = "htpasswd -b ${enctype} /opt/htpasswd/.htpasswd ${name} ${password}" 

# Create .htpasswd file only if user does not exist in current file
  exec {"manage_user_${name}":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => $cmd,
    require => Role_ccw::Htpasswdfile[$name],
    unless  => "grep -c ${name} /opt/htpasswd/.htpasswd"
  }

# Create .htaccess from template
  file { "${location}/.htaccess":
    content       => template('role_ccw/htaccess.erb'),
    mode          => '0440',
    owner         => 'www-data',
    group         => 'www-data',
  }

}
