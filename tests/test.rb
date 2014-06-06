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

options = {
  #:config => './dns.yaml'
  :master     => '192.168.10.10',
  :rndc_key   => './rndc.key'
}

dns = DnsUpdate::load options
entry = DnsUpdate::Entry.new

puts "CHECK: adding a host to the domain\n"

entry.hostname = 'yum101.domain.com'
entry.type = :host
entry.dest = 'yum'
entry.address = '192.168.19.120'
dns.add entry


puts "CHECK: adding a cname to the domain\n"

entry.hostname = 'yum'
entry.type = :cname
entry.dest = 'yum101'
dns.add entry

puts "CHECK: deleting a cname to the domain\n"

entry.hostname = 'yum'
entry.type = :cname
entry.dest = 'yum101'
dns.delete entry

puts "CHECK: adding a reverse ip to the domain\n"

entry.hostname = 'yum'
entry.type = :reverse
entry.address = '192.168.19.100'
dns.add entry

puts 





