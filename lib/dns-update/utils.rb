#
#   Author: Rohith
#   Date: 2014-05-31 16:49:13 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
require 'netaddr'

module DnsUpdate
  module Utils

    Hostname_Regex   = /^(([_[[:alnum:]]]|[_[[:alnum:]]][_a-zA-Z0-9\-]*[[:alnum:]])\.)*([[:alnum:]]|[[:alnum:]][_A-Za-z0-9\-]*[[:alnum:]])$/
    Domain_Regex     = /^[[:alnum:]]+([\-\.]{1}[[:alnum:]]+)*\.[[:alpha:]]{2,5}$/

    def check_hostname(hostname)
      fail 'you have not specified the hostname' unless hostname
      fail "the hostname: #{hostname || 'nil'} is invalid" unless hostname? hostname
    end

    def check_cname(hostname)
      fail 'you have not specified the cname' unless hostname
      fail "the cname: #{hostname || 'nil'} is invalid" unless hostname? hostname
    end

    def check_address(address)
      fail 'you have not specified the address' unless address
      fail "the address: #{address} is invalid" unless address? address
    end

    def check_txt(data)
      fail 'you have not specified the data for the txt' unless data
    end

    def check_subnet(network)
      fail 'you have not specified the subnet' unless network
      fail "the subnet: #{network} is invalid" unless subnet? network
    end

    def check_ttl(ttl)
      fail "the ttl: #{ttl} is invalid" unless ttl? ttl
    end

    def check_type(type)
      raise ArgumentError, "you have not specified a dns type (supported types: #{types.keys.join(', ')}" unless type
      raise ArgumentError, "the type: #{type} is not supported" unless type? type
      types[type]
    end

    def fail(message)
      raise ArgumentError, message
    end

    def ttl?(timetolive)
      true
    end

    def hostname?(hostname)
      hostname =~ Hostname_Regex
    end

    def address?(address)
      begin
        NetAddr::IPv6.parse address
      rescue NetAddr::ValidationError
        begin
          NetAddr::IPv4.parse address
        rescue NetAddr::ValidationError
          return false
        end
      end
      true
    end

    def destination?(destination)
      hostname? destination
    end

    def domain(fqdn)
      fqdn[fqdn.index('.')+1..-1]
    end

    def subnet?(network)
      (parse_address(network).netmask_ext =~ /^(255\.){3}255$/).nil?
    end

    def types
      {
        :record => 'A',
        :aaaa   => 'AAAA',
        :record6 => 'AAAA',
        :cname  => 'CNAME',
        :reverse => 'PTR',
        :service => 'SRV',
        :txt     => 'TXT'
      }
    end

    def type?(type)
      types.has_key? type
    end

    def arpa(network)
      NetAddr::IPv4Net.parse(network).arpa.gsub(/\.$/, '').chomp
    end

    def parse_address(ipaddr)
      begin
        NetAddr::IPv4Net.parse ipaddr
      rescue NetAddr::ValidationError => e
        raise e.message
      end
    end

    def validate_file(filename, writable = false)
      raise ArgumentError, 'you have not specified a file to check' unless filename
      raise ArgumentError, 'the file %s does not exist' % [filename] unless File.exists? filename
      raise ArgumentError, 'the file %s is not a file' % [filename] unless File.file? filename
      raise ArgumentError, 'the file %s is not readable' % [filename] unless File.readable? filename
      if writable
        raise ArgumentError, "the filename #{filename} is not writable" unless File.writable? filename
      end
      filename
    end
  end
end
