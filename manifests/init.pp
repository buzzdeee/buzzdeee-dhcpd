# ----------
# DHCP Server Configuration
# ----------
class dhcpd (
  String  $dnsdomain,
  String  $nameservers,
  Boolean $authoritative      = true,
  Integer $default_lease_time = 3600,
  Integer $max_lease_time     = 86400,
  Boolean $service_enable     = true,
  String  $service_ensure     = 'running',
  Optional[String] $service_flags = undef,
  Hash    $dhcpd_config       = {},
) {

  include dhcpd::params

  $config_file  = $::dhcpd::params::config_file
  $service_name = $::dhcpd::params::service_name

  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    content => template('dhcpd/dhcpd.conf.erb'),
  }

  service { $service_name:
    ensure    => $service_ensure,
    enable    => $service_enable,
    flags     => $service_flags,
    hasstatus => true,
    subscribe => File[$config_file],
    require   => File[$config_file],
  }
}
