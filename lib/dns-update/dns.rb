#
#   Author: Rohith
#   Date: 2014-05-31 16:49:18 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','./')
require 'utils'
require 'settings'
require 'nsupdate'
require 'model'

module DnsUpdate
  class DNS
    include DnsUpdate::Utils
    include DnsUpdate::Settings
    include DnsUpdate::NsUpdate

    def initialize options
      @options = validate_config options
    end

    def update &block
      raise ArgumentError, "you have not specified a block containing configuration" unless block_given?
      model = DnsUpdate::Model.load { |x| yield x }
      model.operation = :update
      model = send model.operation, model 
    end

    def remove &block 
      raise ArgumentError, "you have not specified a block containing configuration" unless block_given?
      model = DnsUpdate::Model.load { |x| yield x }
      model.operation = :remove
      model = send model.operation, model 
    end

    private 
    def set_defaults attributes
      attributes[:ttl] ||= options[:ttl] || 60
      attributes
    end

    def record model 
      validate record_required_fields, set_defaults( entry )
      model = {
        :type => types[:record],
        :zone => domain( entry[:hostname] ),
      }
    end

    def cname entry = {}
      validate cname_required_fields, set_defaults( entry )
      model = {
        :type => types[:cname],
        :zone => domain( entry[:hostname] ),
        :cname => entry[:cname],
      }
    end

    def reverse entry = {}
      model = validate reverse_required_fields, set_defaults( entry )
      model = {
        :type => types[:reverse],
        :zone => arpa( entry[:subnet] ),
      }
    end

    #def nsupdate entry = @entry, print_only = false
    #  result = @template.result( binding )
    #  if print_only 
    #    puts result
    #  else 
    #    IO.popen("nsupdate -y #{@options[:key_name]}:#{@options[:secret]} -v", 'r+') do |f|
    #      f << result
    #      f.close_write
    #      puts f.read
    #    end
    #  end
    #end

    def record_required_fields
      [ :hostname, :address ]
    end

    def cname_required_fields
      [ :hostname, :cname ]
    end

    def reverse_required_fields
      record_required_fields << :subnet
    end

    def validate_config options 
      [ :master, :key_name, :secret ].each do |x| 
        raise ArgumentError, "you have not specified the #{x} option"  unless options.has_key? x 
      end
      # step: check the master ip
      raise ArgumentError, "the master should be a valid ip address"  unless address? options[:master]
      options
    end
  end
end
