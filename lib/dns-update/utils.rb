#
#   Author: Rohith
#   Date: 2014-05-31 16:49:13 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
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
  IPAddress_Regex  = /^([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}$/
  Default_Template = <<-EOF
server <%= @entry[:master] %> 
zone <%= @entry[:domain] %>
<%- if @entry[:op] == :add -%>
update add <%= @entry[:hostname] %>.<%=  @entry[:domain] %>. <%= @entry[:ttl] %> <%= @entry[:type] %> <%= @entry[:dest] %>
<%- else -%>
update delete <%= @entry[:hostname] %>.<%=  @entry[:domain] %>. <%= @entry[:type] %>
<%- end -%>
show 
send
EOF

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

  def address? address
    !( address =~ IPAddress_Regex ).nil?
  end

  def type? type 
    !( type =~ Types_Regex ).nil?
  end

  def ttl? ttl
    ( seconds <= 0 ) ? false : true
  end

  def to_arpa ipaddr 
    ipaddr.split('.').reverse.join('.') << ".in-addr.arpa"
  end

  def record_type type 
    Record_Types[type]
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