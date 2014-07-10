#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-07-10 18:09:40 +0100 (Thu, 10 Jul 2014)
#
#  vim:ts=4:sw=4:et
#
module DnsUpdate
  module Settings
    [ :verbose, :debug ].each do |x|
      define_method "#{x}" do 
        options[x] || false
      end
    end
  end
end

