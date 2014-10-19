# class dhcpd::params
# setting the main parameters for the module
class dhcpd::params {

  case $::operatingsystem {
    'openbsd': {
      $config_file  = '/etc/dhcpd.conf'
      $service_name = 'dhcpd'
    }
    default: {
      fail('Your OS is not supported, help out with patches.')
    }
  }

}
