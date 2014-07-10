#
#   Author: Rohith
#   Date: 2014-05-31 16:49:13 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
require 'netaddr'

module DnsUpdate
  module Utils

    Hostname_Regex   = /^(([[:alnum:]]|[[:alnum:]][a-zA-Z0-9\-]*[[:alnum:]])\.)*([[:alnum:]]|[[:alnum:]][A-Za-z0-9\-]*[[:alnum:]])$/
    Domain_Regex     = /^[[:alnum:]]+([\-\.]{1}[[:alnum:]]+)*\.[[:alpha:]]{2,5}$/

    def check_hostname hostname
      fail "the hostname: #{hostname} is invalid" unless hostname? hostname
    end

    def check_address address
      fail "the address: #{address} is invalid" unless address? address
    end

    def check_destination destination
      fail "the destination: #{destination} is invalid" unless hostname? destination
    end

    def check_subnet network
      fail "the subnet: #{network} is invalid" unless subnet? network
    end

    def check_ttl ttl 
      fail "the ttl: #{ttl} is invalid" unless ttl? ttl
    end

    def fail message
      raise ArgumentError, message
    end

    def ttl? timetolive
      true
    end

    def hostname? hostname
      hostname =~ Hostname_Regex
    end

    def address? address
      NetAddr::CIDR.create address rescue return false
      true
    end

    def destination? destination
      hostname? destination
    end

    def domain fqdn
      fqdn[fqdn.index('.')+1..-1]
    end

    def arpa network 
      check_subnet network
      parse_address( network ).arpa.gsub!( /\.$/,'' )
    end

    def subnet? network 
      (parse_address( network ).netmask_ext =~ /^(255\.){3}255$/ ).nil?
    end

    def types 
      {
        :record => "A",
        :cname  => "CNAME",
        :reverse => "PTR",
        :service => "SRV"
      }
    end

    def type? type 
      types.has_key? type
    end

    def arpa network
      NetAddr::CIDR.create( network ).arpa
    end

    def required options, arguments
      options.each do |x|
        fail "you have not specified the #{x} argument" unless arguments.has_key? x 
      end
    end

    def parse_address ipaddr
      begin 
        NetAddr::CIDR.create ipaddr
      rescue NetAddr::ValidationError => e 
        raise e.message
      end
    end 

    def validate options, arguments
      required options, arguments
      model = {}
      arguments.each_pair do |k,v|
        case k 
        when :hostname
          check_hostname v
        when :address
          check_address v
        when :subnet
          check_subnet v
        when :cname
          check_hostname v
        when :ttl 
          check_ttl v
        end
        model[k] = v
      end
      model
    end

    def validate_file filename, writable = false
      raise ArgumentError, 'you have not specified a file to check'       unless filename
      raise ArgumentError, 'the file %s does not exist'   % [ filename ]  unless File.exists? filename
      raise ArgumentError, 'the file %s is not a file'    % [ filename ]  unless File.file? filename
      raise ArgumentError, 'the file %s is not readable'  % [ filename ]  unless File.readable? filename
      if writable
        raise ArgumentError, "the filename #{filename} is not writable"   unless File.writable? filename
      end
      filename
    end
  end
end
