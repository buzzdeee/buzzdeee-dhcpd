# DHCP module for Puppet

Installs and manages the ISC DHCP daemon.

## Features

* Multiple subnet support
* Host reservations
* Secure dynamic DNS updates when combined with Bind
* Failover
* Works on Debian, FreeBSD, Darwin
* In production for over two years supporting several hundred clients in
  multiple subnet VLANs

## Usage
Define the server and the zones it will be responsible for.

    class { 'dhcp':
      dnsdomain    => [
        'dc1.example.net',
        '1.0.10.in-addr.arpa',
        ],
      nameservers  => ['10.0.1.20'],
      ntpservers   => ['us.pool.ntp.org'],
      interfaces   => ['eth0'],
      dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
      require      => Bind::Key[ $ddnskeyname ],
      pxeserver    => '10.0.1.50',
      pxefilename  => 'pxelinux.0',
    }

### dhcp::pool
Define the pool attributes

    dhcp::pool{ 'ops.dc1.example.net':
      network => '10.0.1.0',
      mask    => '255.255.255.0',
      range   => '10.0.1.100 10.0.1.200',
      gateway => '10.0.1.1',
    }


### dhcp::host
Create host reservations.

    dhcp::host {
      'server1': mac => "00:50:56:00:00:01", ip => "10.0.1.51";
      'server2': mac => "00:50:56:00:00:02", ip => "10.0.1.52";
      'server3': mac => "00:50:56:00:00:03", ip => "10.0.1.53";
    }

### dhcp::failover

The ISC DHCPd also supports failover and load balancing between a pair of DHCP
servers.  This proves very handy when you really rely on your DHCP servers.

On the master, inform the master that it should be such:

    class { dhcp::failover:
      peer_address => $slaveserver_ip,
    }

While on the slave, inform it of its lowly status:

    class { dhcp::failover:
      role         => "secondary",
      peer_address => $masterserver_ip,
    }

You then need to tell your pools that it should balance itself out between
masters.  I use DHCP failover for all of the pools I am managing, so a simple
default is all I need for this.

    Dhcp::Pool { failover => "dhcp-failover" }

## Contributors

Zach Leslie <zach.leslie@gmail.com>
Ben Hughes <git@mumble.org.uk>

