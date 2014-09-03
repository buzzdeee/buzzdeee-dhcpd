# ----------
# Host Reservation
# ----------
define dhcp::host (
  $ip,
  $mac,
  $comment=''
  $nextserver = false,
  $filename = false,
  $rootpath = false,
) {

  $host = $name
  include dhcp::params

  $config_file = $dhcp::params::config_file

  concat::fragment { "dhcp_host_${name}":
    target  => $config_file
    content => template('dhcp/dhcpd.host.erb'),
    order   => 10,
  }
}

