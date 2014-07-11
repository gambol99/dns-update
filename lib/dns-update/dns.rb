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
require 'validate'
require 'model'

module DnsUpdate
  class DNS
    include DnsUpdate::Utils
    include DnsUpdate::Settings
    include DnsUpdate::NsUpdate
    include DnsUpdate::Validate

    def initialize options
      @settings = validate_config options
    end

    def update &block 
      raise ArgumentError, "you have not specified a block containing configuration" unless block_given?
      # step: load the dns entry model from the client
      model = DnsUpdate::Model.load { |x| yield x }
      # step: set the operation 
      model.operation = :update
      # step: perform the operation
      perform model
    end

    def remove &block 
      raise ArgumentError, "you have not specified a block containing configuration" unless block_given?
      # step: load the dns entry model from the client
      model = DnsUpdate::Model.load { |x| yield x }
      # step: set the operation 
      model.operation = :remove
      # step: perform the operation
      perform model
    end

    private
    def perform model 
      # step: insert any defaults
      model = set_defaults model 
      # step: check a type has been specified
      check_type model.type
      # step: call the validation code on the dns entry type
      send "validate_#{model.operation}_#{model.type}", model 
      # step: set the type if not there
      model.type = check_type model.type
      # step: call the dns update 
      nsupdate model
    end
  end
end
