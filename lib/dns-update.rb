#
#   Author: Rohith
#   Date: 2014-05-31 16:49:01 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
module DnsUpdate
  def self.path filename 
    ROOT ||= File.expand_path( File.dirname( __FILE__ ) )
    "#{ROOT}/dns-update/#{filename}"
  end
  require path "version"

  autoload :Version, path "version"
  autoload :Settings, path "settings"
  autoload :Utils, path "utils"
  autoload :DNS, path "dns"

  def self.version
    DnsUpdate::VERSION
  end 

  def self.load options 
    DnsUpdate::DNS::new( options )
  end
end
