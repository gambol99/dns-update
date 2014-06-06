#!/usr/bin/env ruby
#
#   Author: Rohith
#   Date: 2014-05-31 16:49:01 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
module DnsUpdate
  ROOT = File.expand_path File.dirname __FILE__

  require "#{ROOT}/dns-update/version"

  autoload :Version,    "#{ROOT}/dns-update/version"
  autoload :Utils,      "#{ROOT}/dns-update/utils"
  autoload :DNS,        "#{ROOT}/dns-update/dns"

  def self.version
    DnsUpdate::VERSION
  end 

  def self.load options 
    DnsUpdate::DNS::new( options )
  end

end
