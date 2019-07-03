[![Build Status](https://drone.io/github.com/gambol99/dns-update/status.png)](https://drone.io/github.com/gambol99/dns-update/latest)

DNS Update
-----------

Is a very quick and small gem which acts as a wrapper for dynamic dns via nsupdate calls.

Example Use:
-----------

    options = {
      :master     => '192.168.10.12',
      :key_name   => 'rndc-key',
      :secret     => './rndc.key',
      :print_only => true
    }

    dns = DnsUpdate::load options

    announce "CHECK: adding a host to the domain"
    dns.update { |m|
      m.type = :record
      m.hostname = "yum101.domain.com"
      m.address = "192.168.19.20"
    }
    announce "CHECK: adding a cname to the domain"
    dns.update { |m|
      m.type = :cname
      m.hostname = "yum.domain.com"
      m.cname = "yum101.domain.com"
    }
    announce "CHECK: adding a txt to the domain"
    dns.update { |m|
      m.type = :txt
      m.hostname = "yum.domain.com"
      m.data = "some fun stuff"
    }
    announce "CHECK: adding a reverse to the domain"
    dns.update { |m|
      m.type = :reverse
      m.hostname = "yum.domain.com"
      m.address = "192.168.19.20"
      m.subnet = "192.168.19.0/24"
    }

    # REMOVAL
    announce "CHECK: removing a host to the domain"
    dns.remove { |m|
      m.type = :record
      m.hostname = "yum101.domain.com"
    }

    announce "CHECK: removing a cname to the domain"
    dns.remove { |m|
      m.type = :cname
      m.hostname = "yum.domain.com"
    }
    announce "CHECK: removing a txt to the domain"
    dns.remove { |m|
      m.type = :txt
      m.hostname = "yum.domain.com"
    }
    announce "CHECK: removing a reverse to the domain"
    dns.remove { |m|
      m.type = :reverse
      m.hostname = "yum.domain.com"
      m.address = "192.168.19.20"
      m.subnet = "192.168.19.0/24"
    }

