#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-07-11 10:44:41 +0100 (Fri, 11 Jul 2014)
#
#  vim:ts=4:sw=4:et
#
module DnsUpdate
  module Validate
    def validate_update_record model 
      check_hostname model.hostname
      check_address model.address
      check_ttl model.ttl
      model.zone = domain( model.hostname )
      model 
    end

    def validate_update_cname model
      check_hostname model.hostname
      check_cname model.cname 
      check_ttl model.ttl 
      model.zone = domain( model.hostname )
      model
    end

    def validate_update_reverse model 
      check_hostname model.hostname
      check_address model.address
      check_subnet model.subnet
      model.zone = arpa model.subnet
      model.address = arpa model.address
      model
    end

    def validate_remove_record model 
      check_hostname model.hostname
      model.zone = domain( model.hostname )
      model 
    end

    def validate_remove_cname model
      check_hostname model.hostname
      model.zone = domain( model.hostname )
      model
    end

    def validate_remove_reverse model 
      check_address model.address 
      check_subnet model.subnet
      model.zone = arpa model.subnet
      model.address = arpa model.address
      model
    end

    def set_defaults model 
      model.ttl = settings[:ttl] || 60 unless model.ttl 
      model
    end
  end
end

