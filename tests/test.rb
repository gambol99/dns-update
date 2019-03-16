#!/usr/bin/env ruby
#
#   Author: Rohith
#   Date: 2014-05-31 16:49:35 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','../lib')
require 'dns-update'
require 'pp'

def announce(message)
  puts "\n ** " << message << "\n\n"
end

options = {
  :master     => '192.168.1.2',
  :key_name   => 'hmac-sha256:keyname',
  :secret     => 'stuff',
  :print_only => true
}

dns = DnsUpdate::load options

announce 'CHECK: adding a host to the domain'
dns.update { |m|
  m.type = :record
  m.hostname = 'yum101.dasblinkenled.org'
  m.address = '192.168.19.20'
  m.ttl = 100
}

announce 'CHECK: adding a host with leading _ to the domain'
dns.update { |m|
  m.type = :record
  m.hostname = '_yum101.dasblinkenled.org'
  m.address = '192.168.19.20'
  m.ttl = 100
}

announce 'CHECK: adding a cname to the domain'
dns.update { |m|
  m.type = :cname
  m.hostname = 'yum.dasblinkenled.org'
  m.cname = 'yum101.dasblinkenled.org'
}

announce "CHECK: adding a txt to the domain"
dns.update { |m|
  m.type = :txt
  m.hostname = "yum101.dasblinkenled.org"
  m.data = "some fun stuff"
}

# BROKEN
if false
announce 'CHECK: adding a reverse to the domain'
dns.update { |m|
  m.type = :reverse
  m.hostname = 'yum.dasblinkenled.org'
  m.address = '192.168.19.20'
  m.subnet = '192.168.19.0/24'
}
end

# REMOVAL
announce 'CHECK: removing a host to the domain'
dns.remove { |m|
  m.type = :record
  m.hostname = 'yum101.dasblinkenled.org'
}

announce 'CHECK: removing a cname to the domain'
dns.remove { |m|
  m.type = :cname
  m.hostname = 'yum.dasblinkenled.org'
}

announce "CHECK: removing a txt to the domain"
dns.remove { |m|
  m.type = :txt
  m.hostname = "yum.domain.com"
}

if false
announce 'CHECK: removing a reverse to the domain'
dns.remove { |m|
  m.type = :reverse
  m.hostname = 'yum.dasblinkenled.org'
  m.address = '192.168.19.20'
  m.subnet = '192.168.19.0/24'
}
end
