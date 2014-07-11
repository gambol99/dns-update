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
server <%= @master %>
zone <%= @model.zone %>.
<%- if @model.operation == :update -%>
  <%- if @model.type == 'A' -%>
update add <%= @model.hostname %>. <%= @model.ttl %> <%= @model.type %> <%= @model.address %>
  <%- elsif @model.type == 'CNAME' -%>
update add <%= @model.hostname %>. <%= @model.ttl %> <%= @model.type %> <%= @model.cname %>          
  <%- elsif @model.type == 'PTR' -%> 
update add <%= @model.address %> <%= @model.ttl %> <%= @model.type %> <%= @model.hostname %>                  
  <%- end -%>
<%- else -%>
  <%- if @model.type == 'A' -%>
update delete <%= @model.hostname %>. <%= @model.type %>
  <%- elsif @model.type == 'CNAME' -%>
update delete <%= @model.hostname %>. <%= @model.type %>        
  <%- elsif @model.type == 'PTR' -%>
update delete <%= @model.address %>. <%= @model.type %>        
  <%- end -%>
<%- end -%>
show 
send
EOF
    def nsupdate model 
      render = render_update model 
      if !model.print_only && !settings[:print_only]
        status = IO.popen("nsupdate -y #{settings[:key_name]}:#{settings[:secret]} -v", 'r+') do |f|
          f << render
          f.close_write
          puts f.read
        end        
      else 
        puts render
      end
    end

    private 

    def render_update model
      @model  = model 
      @master = settings[:master]
      ERB.new( template, nil, '-' ).result( binding ) 
    end

    def template
      settings[:template] || default_template
    end

    def default_template
      Default_Template
    end
  end
end

