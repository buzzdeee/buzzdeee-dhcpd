# ----------
# DHCP Server Configuration
# ----------
class dhcpd (
  $dnsdomain,
  $nameservers,
  $authoritative       = true,
  $default_lease_time  = 3600,
  $max_lease_time      = 86400,
  $service_enable      = true,
  $service_ensure      = 'running',
  $service_flags       = undef,
) {

  include dhcpd::params

  $config_file  = $::dhcpd::params::config_file
  $service_name = $::dhcpd::params::service_name

  # Build up the dhcpd.conf
  concat { $::dhcpd::params::config_file: 
    owner => 'root',
    group => '0',
    mode  => '0644',
    order => 'numeric',
  }

  concat::fragment { 'dhcpd-conf-header':
    target  => $config_file,
    content => template('dhcpd/dhcpd.conf-header.erb'),
    order   => 1,
  }

  service { $service_name:
    ensure    => $service_ensure,
    enable    => $service_enable,
    flags     => $service_flags,
    hasstatus => true,
    subscribe => Concat[$config_file],
    require   => Concat[$config_file],
  }

}
