#
#
#   Author: Rohith
#   Date: 2014-07-10 22:40:02 +0100 (Thu, 10 Jul 2014)
#
#  vim:ts=4:sw=4:et
#
module DnsUpdate
  class Model
    attr_accessor :address, :domain, :zone, :hostname, :subnet, :ttl, :cname, :type, :operation

    def self.load &block
      model = Model.new
      yield model
      model
    end
  end
end
