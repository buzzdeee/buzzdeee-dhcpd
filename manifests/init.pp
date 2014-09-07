# ----------
# DHCP Server Configuration
# ----------
class dhcpd (
  $dnsdomain,
  $nameservers,
  $authoritative       = true,
  $default_lease_time  = 3600,
  $max_lease_time      = 86400,
  $shared_network      = true,
  $shared_network_name = '',
  $service_enable      = true,
  $service_ensure      = 'running',
) {

  include dhcpd::params

  $config_file  = $::dhcpd::params::config_file
  $service_name = $::dhcpd::params::service_name

  # Build up the dhcpd.conf
  concat { $::dhcpd::params::config_file: 
    order => 'numeric',
  }

  concat::fragment { 'dhcpd-conf-header':
    target  => $config_file,
    content => template('dhcpd/dhcpd.conf-header.erb'),
    order   => 1,
  }

  unless ( $shared_network ) {
    concat::fragment { 'dhcpd-share-network-header':
      target  => $::dhcpd::params::config_file,
      content => template('dhcpd/dhcpd.share-network-header.erb'),
      order   => 5,
    }
    concat::fragment { 'dhcpd-share-network-footer':
      target  => $::dhcpd::params::config_file,
      content => template('dhcpd/dhcpd.share-network-footer.erb'),
      order   => 99,
    }
  }

  service { $service_name:
    ensure    => $service_ensure,
    enable    => $service_enable,
    hasstatus => true,
    subscribe => Concat[$config_file],
    require   => Concat[$config_file],
  }

}
