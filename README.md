# Manage OpenBSD's DHCP Server with Puppet

This module manages the DHCP server daemon found in the base installation of OpenBSD.

## Features

* Multiple subnet support
* Host reservations
* Only works on OpenBSD

## Usage

Define the server and the zones it will be responsible for.

```Puppet
class { 'dhcp':
  dnsdomain    => [
    'dc1.example.net',
    ],
  nameservers  => ['10.0.1.20'],
}
```

### dhcp::subnet

Define the subnet attributes

```Puppet
dhcp::pool{ 'ops.dc1.example.net':
  network => '10.0.1.0',
  netmask => '255.255.255.0',
  range   => '10.0.1.100 10.0.1.200',
  routers => '10.0.1.1',
}
```

### dhcp::host
Create host reservations.

```Puppet
dhcp::host {
  'server1': mac => "00:50:56:00:00:01", ip => "10.0.1.51";
  'server2': mac => "00:50:56:00:00:02", ip => "10.0.1.52";
  'server3': mac => "00:50:56:00:00:03", ip => "10.0.1.53";
}
```

## Contribute

Please help me make this module awesome!  Send pull requests and file issues.

