#!/usr/bin/env ruby
#
#   Author: Rohith
#   Date: 2014-05-31 16:49:35 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','../lib')
require 'dns-update'
require 'colorize'
require 'pp'

def announce message
  puts message.green << "\n"
end

options = {
  :master     => '192.168.10.10',
  :key_name   => 'rndc-key',
  :secret     => './rndc.key'
}

dns = DnsUpdate::load options

#announce "CHECK: adding a host to the domain"
#dns.update { |m|
#  m.type = :record
#  m.hostname = "yum101.domain.com"
#  m.address = "192.168.19.20"
#}

#announce "CHECK: adding a cname to the domain"
#dns.update { |m|
#  m.type = :cname
#  m.hostname = "yum.domain.com"
#  m.cname = "yum101.domain.com"
#}
#
announce "CHECK: adding a reverse to the domain"
dns.update { |m|
  m.type = :reverse
  m.hostname = "yum.domain.com"
  m.address = "192.168.19.20"
  m.subnet = "192.168.19.0/24"
}

# REMOVAL
#announce "CHECK: removing a host to the domain"
#dns.remove { |m|
#  m.type = :record
#  m.hostname = "yum101.domain.com"
#}
#
#announce "CHECK: removing a cname to the domain"
#dns.remove { |m|
#  m.type = :cname
#  m.hostname = "yum.domain.com"
#}

announce "CHECK: removing a reverse to the domain"
dns.remove { |m|
  m.type = :reverse
  m.hostname = "yum.domain.com"
  m.address = "192.168.19.20"
  m.subnet = "192.168.19.0/24"
}
