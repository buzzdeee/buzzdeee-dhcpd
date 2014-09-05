class dhcpd::params {

  case $operatingsystem {
    'openbsd': {
      $config_file  = '/etc/dhcpd.conf'
      $service_name = 'dhcpd'
    }
    default: {
      fail("Your OS is not supported, help out with patches.")
    }
  }

}
