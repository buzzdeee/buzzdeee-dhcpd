# ----------
# Shared Network
# ----------
define dhcpd::sharednetwork {

  include dhcpd::params

  $config_file = $dhcpd::params::config_file

  concat::fragment { "dhcpd_sharednetwork-header_${name}":
    target  => $config_file,
    content => template('dhcpd/dhcpd.sharednetwork-header.erb'),
    order   => '5',
  }
  concat::fragment { "dhcpd_sharednetwork-footer_${name}":
    target  => $config_file,
    content => template('dhcpd/dhcpd.sharednetwork-footer.erb'),
    order   => '100',
  }
}

