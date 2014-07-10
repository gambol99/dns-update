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

announce "CHECK: adding a host to the domain"
dns.update { |m|
  m.type = :record
  m.hostname = "yum101.domain.com"
  m.address = "192.168.19.20"
}

#announce "CHECK: adding a cname to the domain"
#dns.cname(
#  :hostname => "yum.domain.com",
#  :cname  => "yum101.domain.com"
#) 
#
#announce "CHECK: adding a reverse to the domain"
#dns.reverse(
#  :hostname => "yum.domain.com",
#  :address  => "192.168.19.20",
#  :subnet  => "192.168.19.0/24"
#)

#entry.hostname = 'yum101.domain.com'
#entry.type     = :host
#entry.dest     = 'yum'
#entry.address  = '192.168.19.120'
#dns.add entry
#
#
#puts "CHECK: adding a cname to the domain\n"
#
#entry.hostname = 'yum'
#entry.type     = :cname
#entry.dest     = 'yum101'
#dns.add entry
#
#puts "CHECK: deleting a cname to the domain\n"
#
#entry.hostname = 'yum'
#entry.type     = :cname
#entry.dest     = 'yum101'
#dns.delete entry
#
#puts "CHECK: adding a reverse ip to the domain\n"
#
#entry.hostname = 'yum'
#entry.type     = :reverse
#entry.address  = '192.168.19.100'
#entry.subnet   = '192.168.19.0/24'
#dns.add entry
#
#puts "CHECK: delete a ptr record from domain\n"
#
#entry.hostname = 'yum'
#entry.type     = :reverse
#entry.address  = '192.168.19.100'
#entry.subnet   = '192.168.19.0/24'
#dns.delete entry

puts 





