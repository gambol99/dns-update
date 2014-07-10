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
    Default_Template = <<-EOF
server <%= @entry[:master] %> 
zone <%= @entry[:zone] %>
<%- if @entry[:op] == :add -%>
update add <%= @entry[:hostname] %>.<%=  @entry[:domain] %>. <%= @entry[:ttl] %> <%= @entry[:type] %> <%= @entry[:dest] %>
<%- else -%>
update delete <%= @entry[:hostname] %>.<%=  @entry[:domain] %>. <%= @entry[:type] %>
<%- end -%>
show 
send
EOF

    #update add 25.123.168.192.in-addr.arpa. 86400 PTR mail.example.local.
    def hostname? hostname
      !( hostname =~ Hostname_Regex ).nil?
    end

    def address? address
      NetAddr::CIDR.create address rescue return false
      true
    end

    def destination? destination
      hostname? destination
    end

    def subnet? network

    end

    def ttl? ttl 

    end

    def check_ttl ttl 
      fail "the ttl: #{ttl} is invalid" unless ttl? ttl
    end

    def check_hostname hostname
      fail "the hostname: #{hostname} is invalid" unless hostname? hostname
    end

    def check_address address
      fail "the address: #{address} is invalid" unless address? address
    end

    def check_destination destination
      fail "the destination: #{destination} is invalid" unless hostname? destination
    end

    def integer? int 
      if int.is_a? String
        raise ArgumentError, "the #{name}: #{seconds} is invalid; must be numeric"  unless int =~ /^[[:digit:]]+$/
        int = int.to_i  
      end
      int
    end

    def types 
      %(cname a ptr svr)
    end

    def type? type 
      types.include? type
    end

    def domain? domain 
      !( domain =~ Domain_Regex ).nil?
    end

    def arpa network
      NetAddr::CIDR.create( network ).arpa
    end

    def ttl? ttl
      ( seconds <= 0 ) ? false : true
    end

    def required options, arguments
      options.each do |x|
        fail "you have not specified the #{x} arguments" unless arguments.has_key? x 
      end
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
