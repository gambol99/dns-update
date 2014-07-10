#
#
#   Author: Rohith
#   Date: 2014-07-10 21:25:01 +0100 (Thu, 10 Jul 2014)
#
#  vim:ts=4:sw=4:et
#
require 'erb'
require 'pp'

module DnsUpdate
  module NsUpdate

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

    def nsupdate model 
      PP.pp model

    end

    private 

    def template
      options[:template] || default_template
    end

    def default_template
      Default_Template
    end

  end
end

