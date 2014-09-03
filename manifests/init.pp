# ----------
# DHCP Server Configuration
# ----------
class dhcp (
  $dnsdomain,
  $nameservers,
  $ntpservers,
  $authoritative       = true,
  $dhcp_conf_header    = 'dhcpd/dhcpd.conf-header.erb', # default template
  $dhcp_conf_extra     = 'dhcpd/dhcpd.conf-extra.erb',  # default template
  $dhcp_conf_fragments = {},
  $default_lease_time  = 3600,
  $max_lease_time      = 86400,
) {

  include dhcp::params

  $dhcp_dir    = $dhcp::params::dhcp_dir
  $packagename = $dhcp::params::packagename
  $servicename = $dhcp::params::servicename
  $dhcpd       = $dhcp::params::dhcpd

  # Incase people set interface instead of interfaces work around
  # that. If they set both, use interfaces and the user is a unwise
  # and deserves what they get.
  if $interface != 'NOTSET' and $interfaces == undef {
    $dhcp_interfaces = [ $interface ]
  } elsif $interface == 'NOTSET' and $interfaces == undef {
    fail ("You need to set \$interfaces in ${module_name}")
  } else {
    $dhcp_interfaces = $interfaces
  }

  package { $packagename:
    ensure => installed,
  }

  include concat::setup
  Concat { require => Package[$packagename] }

  #
  # Build up the dhcpd.conf
  concat {  "${dhcp_dir}/dhcpd.conf": }

  concat::fragment { 'dhcp-conf-header':
    target  => "${dhcp_dir}/dhcpd.conf",
    content => template($dhcp_conf_header),
    order   => 01,
  }

  concat::fragment { 'dhcp-conf-extra':
    target  => "${dhcp_dir}/dhcpd.conf",
    content => template($dhcp_conf_extra),
    order   => 99,
  }

  # Any additional dhcpd.conf fragments the user passed in as a hash for
  # create_resources.  This allows the end user almost total control over the
  # DHCP server without modifying this module at all.

  # JJM This is commented out because the create_resources in PE does not
  # support the third option.
  # $fragment_defaults = {
  #   content => "# Managed by Puppet\n",
  #   target  => "${dhcp_dir}/dhcpd.conf",
  #   order   => 80,
  # }
  create_resources('concat::fragment', $dhcp_conf_fragments)

  #
  # Build the dhcpd.pools
  concat { "${dhcp_dir}/dhcpd.pools": }

  concat::fragment { 'dhcp-pools-header':
    target  => "${dhcp_dir}/dhcpd.pools",
    content => "# DHCP Pools\n",
    order   => 01,
  }

  #
  # Build the dhcpd.hosts
  concat { "${dhcp_dir}/dhcpd.hosts": }

  concat::fragment { 'dhcp-hosts-header':
    target  => "${dhcp_dir}/dhcpd.hosts",
    content => "# static DHCP hosts\n",
    order   => 01,
  }

  service { $servicename:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [Concat["${dhcp_dir}/dhcpd.pools"], Concat["${dhcp_dir}/dhcpd.hosts"], File["${dhcp_dir}/dhcpd.conf"]],
    require   => Package[$packagename],
    restart   => "${dhcpd} -t && service ${servicename} restart",
  }

}
