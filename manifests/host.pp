# ----------
# Host Reservation
# ----------
define dhcpd::host (
  $ip,
  $mac,
  $comment    = '',
  $nextserver = false,
  $filename   = false,
  $rootpath   = false,
  $rfc1048    = false,
) {

  include dhcpd::params

  $config_file = $dhcpd::params::config_file

  concat::fragment { "dhcpd_host_${name}":
    target  => $config_file,
    content => template('dhcpd/dhcpd.host.erb'),
    order   => '20',
  }
}
