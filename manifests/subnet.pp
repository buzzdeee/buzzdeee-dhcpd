# ----------
# Subnet 
# ----------
define dhcpd::subnet (
  $network,
  $netmask,
  $routers    = undef,
  $range      = undef,
  $options    = '',
  $parameters = '',
) {

  include dhcpd::params

  $config_file = $dhcpd::params::config_file

  concat::fragment { "dhcpd_subnet-header_${name}":
    target  => $config_file,
    content => template('dhcpd/dhcpd.subnet-header.erb'),
    order   => '5',
  }
  concat::fragment { "dhcpd_subnet-footer_${name}":
    target  => $config_file,
    content => template('dhcpd/dhcpd.subnet-footer.erb'),
    order   => '90',
  }
}
