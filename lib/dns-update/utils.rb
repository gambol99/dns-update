#
#   Author: Rohith
#   Date: 2014-05-31 16:49:13 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
require 'netaddr'

module DnsUpdate
module Utils

  Record_Types     = {
    :host    => 'A',
    :cname   => 'CNAME',
    :reverse => 'PTR'
  }

  Hostname_Regex   = /^(([[:alnum:]]|[[:alnum:]][a-zA-Z0-9\-]*[[:alnum:]])\.)*([[:alnum:]]|[[:alnum:]][A-Za-z0-9\-]*[[:alnum:]])$/
  Domain_Regex     = /^[[:alnum:]]+([\-\.]{1}[[:alnum:]]+)*\.[[:alpha:]]{2,5}$/
  Types_Regex      = /^(host|cname|reverse)$/
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

  def is_integer value, name = 'value'
    if value.is_a? String
      raise ArgumentError, "the #{name}: #{seconds} is invalid; must be numeric"  unless value =~ /^[[:digit:]]+$/
      value = value.to_i  
    end
    value
  end

  def hostname? hostname 
    !( hostname =~ Hostname_Regex ).nil?
  end

  def domain? domain 
    !( domain =~ Domain_Regex ).nil?
  end

  def subnet? address
    address? address
  end

  def address? address
    begin 
      NetAddr::CIDR.create address
      true
    rescue IPAddr::InvalidAddressError => e 
      false 
    end
  end

  def arpa network
    NetAddr::CIDR.create( network ).arpa
  end

  def type? type 
    !( type =~ Types_Regex ).nil?
  end

  def ttl? ttl
    ( seconds <= 0 ) ? false : true
  end

  def record_type type 
    Record_Types[type]
  end

  def required options, arguments
    options.each do |x|
      raise ArgumentError, "you have not specified the #{x} arguments" unless arguments.has_key? x 
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
