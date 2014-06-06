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

  Fields = [ :address, :domain, :type, :ttl, :hostname, :dest ]

  def initialize 
    @entry = {}
    @entry[:ttl] = 60
  end

  Fields[0..4].each do |x|
    define_method "#{x}=" do |value|
      raise ArgumentError, "the #{x}: #{value} is invalid, please check" unless self.send( "#{x}?", value )
      @entry[x] = value
    end
  end

  Fields.each do |x|
    define_method "#{x}" do 
      @entry[x]
    end
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
      :type     => record_type( self.type )
    }
    case self.type
    when :host
      model[:dest]      = self.address
    when :cname 
      model[:dest]      = self.dest << "." << self.domain if operation == :add 
      model[:hostname]  = self.hostname 
    when :reverse
      model[:hostname]  = to_arpa self.address
      model[:domain]    = to_arpa self.address
    end
    model
  end

  def is_valid operation
    [ :hostname, :domain, :type ].each do |x|
      raise ArgumentError, "you have not specified a #{x}" unless @entry.has_key? x
    end
    case @entry[:type]
    when :host 
      if operation == :add 
        raise ArgumentError, "you have not specified an ip address" unless @entry.has_key? :address
      end
    when :cname 
      if operation == :add 
        raise ArgumentError, "you have not specified a destination for the cname" unless @entry.has_key? :dest
      end
    when :reverse
      raise ArgumentError, "you have not specified a ip address" unless @entry.has_key? :address
    end
  end

end
end
