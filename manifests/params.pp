class dhcp::params {

  case $operatingsystem {
    'openbsd': {
      $config_file = '/etc/dhcpd.conf'
      $servicename = 'dhcpd'
    }
    default: {
      fail("Your OS is not supported, help out with patches.")
    }
  }

}
