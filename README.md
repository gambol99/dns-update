DNS Update
-----------

Is a very quick and small gem which acts as a wrapper for dynamic dns via nsupdate calls.

Example Use:
-----------

    require 'dns-update'
    require 'pp'

    options = {
      #:config => './dns.yaml'
      :master     => '192.168.10.10',
      :rndc_key   => './rndc.key'
    }
    
    dns = DnsUpdate::load options
    entry = DnsUpdate::Entry.new
    
    puts "CHECK: adding a host to the domain\n"
    
    entry.hostname = 'yum101.hq.domain.com'
    entry.type = :host
    entry.dest = 'yum'
    entry.address = '192.168.19.120'
    dns.add entry
    
    
    puts "CHECK: adding a cname to the domain\n"
    
    entry.hostname = 'yum'
    entry.type = :cname
    entry.dest = 'yum101'
    dns.add entry
    
Template
--------

The nsupdate input is rendered by a default template which you can override by the options[:template]. The default is given below

    server <%= @entry[:master] %> 
    zone <%= @entry[:domain] %>.
    <%- if @entry[:op] == :add -%>
    update add <%= @entry[:hostname] %> <%= @entry[:ttl] %> <%= @entry[:type] %> <%= @entry[:dest] %>
    <%- else -%>
    update delete <%= @entry[:hostname] %> <%= @entry[:type] %>
    <%- end -%>
    show 
    send