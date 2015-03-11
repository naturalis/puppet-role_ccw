# == Define: role_ccw::htpasswdfile
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
define role_ccw::htpasswdfile($file)
{
  exec{"auth_file_${name}":
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    onlyif      => "test ! -f ${file}",
    command     => "touch ${file}"
  }
}