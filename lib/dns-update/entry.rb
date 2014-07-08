#
#   Author: Rohith
#   Date: 2014-05-31 16:49:18 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
require 'utils'

module DnsUpdate
  class Entry

    include DnsUpdate::Utils

    Fields = [ :address, :domain, :subnet, :type, :ttl, :hostname, :dest ]

    def initialize 
      @entry = {}
      @entry[:ttl] = 60
    end

    Fields.each do |x|
      define_method "#{x}=" do |value|
        raise ArgumentError, "the #{x}: #{value} is invalid, please check" unless self.send( "#{x}?", value )
        @entry[x] = value
      end
    end

    Fields.each do |x|
      define_method "#{x}" do; @entry[x]; end
    end

    def hostname=(name) 
      raise ArgumentError, "the hostname: #{hostname} is not valid" unless hostname? name
      if name =~ /\./
        @entry[:hostname] = name.split('.').first
        @entry[:domain]   = name[name.index('.')+1,name.size]
      else
        @entry[:hostname] = name
      end
    end

    def dest=(name)
      raise ArgumentError, "the dest: #{hostname} is invalid" unless hostname? name
      @entry[:dest] = name
    end

    def model operation = :add
      model = {
        :hostname => self.hostname,
        :domain   => self.domain,
        :ttl      => self.ttl,
        :type     => record_type( self.type ),
        :zone     => self.domain
      }
      case self.type
      when :host
        model[:dest]      = self.address
      when :cname 
        model[:dest]      = self.dest << "." << self.domain if operation == :add 
        model[:hostname]  = self.hostname 
      when :reverse
        # tmpl: update add <%= @entry[:hostname] %>.<%=  @entry[:domain] %>. <%= @entry[:ttl] %> <%= @entry[:type] %> <%= @entry[:dest] %>
        # update add 254.123.168.192.in-addr.arpa. 38400 PTR gateway.example.local.
        model[:dest]      = self.dest << "." << self.domain 
        model[:hostname]  = arpa( self.address  ).split( '.in-addr.arpa' ).first
        model[:zone]      = arpa( self.subnet ) 
      end
      model
    end

    def is_valid operation
      required [ :hostname, :domain, :type ], @entry
      case @entry[:type]
      when :host 
        required [ :address ], @entry if operation == :add 
      when :cname 
        required [ :dest ], @entry if operation == :add 
      when :reverse
        required [ :address, :subnet ], @entry
      end
    end
end
end
