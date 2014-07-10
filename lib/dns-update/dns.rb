#
#   Author: Rohith
#   Date: 2014-05-31 16:49:18 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','./')
require 'utils'
require 'entry'
require 'yaml'
require 'erb'

module DnsUpdate
  class DNS
    
    include DnsUpdate::Utils
    include DnsUpdate::Settings

    def initialize options
      options = validate_config options
    end

    def options
      @options
    end

    def record hostname, address, attrs
      check_hostname hostname
      check_address address
      attributes = set_attribute_defaults attrs
      m = model.define {
        host = hostname
        address = address
        ttl = attributes[:ttl]
      }
    end

    def cname hostname, destination, attrs
      check_hostname hostname
      check_hostname destination
      attributes = set_attribute_defaults attrs


    end

    def reverse hostname, address, subnet, attrs
      check_hostname hostname
      check_hostname destination
      attributes = set_attribute_defaults attrs


    end

    private 
    def set_attribute_defaults attributes 
      attributes[:ttl] ||= options[:ttl] || 60
      attributes
    end

    def fail message 

    end

    def add entry
      dns_master = validate_entry entry, :add
      @entry          = entry.model :add
      @entry[:master] = dns_master 
      @entry[:op]     = :add
      nsupdate @entry
    end

    def delete entry 
      dns_master = validate_entry entry, :delete
      @entry          = entry.model :delete
      @entry[:master] = dns_master 
      @entry[:op]     = :delete
      nsupdate @entry
    end

    def template
      Default_Template
    end

    private
    def validate_entry entry, operation = :add 
      # step: check the entry is valid
      entry.is_valid operation
      # step: lets get the dns master for this request
      @options[:master]
    end

    def nsupdate entry = @entry, print_only = false
      result = @template.result( binding )
      if print_only 
        puts result
      else 
        IO.popen("nsupdate -y #{@options[:key_name]}:#{@options[:secret]} -v", 'r+') do |f|
          f << result
          f.close_write
          puts f.read
        end
      end
    end

    def validate_config options 
      [ :master, :key_name, :secret ].each do |x| 
        raise ArgumentError, "you have not specified the #{x} option"  unless options.has_key? x 
      end
      # step: check the master ip
      raise ArgumentError, "the master should be a valid ip address"  unless address? options[:master]
      # step: load the template
      @template = ERB.new( Default_Template, nil, '-' )
      options
    end
  end
end
