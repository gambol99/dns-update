#!/usr/bin/ruby
#
#   Author: Rohith
#   Date: 2014-05-31 16:49:09 +0100 (Sat, 31 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','lib/dns-update' )
require 'version'

Gem::Specification.new do |s|
  s.name        = 'dns-update'
  s.version     = DnsUpdate::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2019-03-15'
  s.authors     = ['Rohith Jayawardene', 'Michael Richardson']
  s.email       = 'gambol99@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/dns-update'
  s.summary     = %q{A gem library used for dyanmic dns updates}
  s.description = %q{Provides a ruby wrapper for nsupdates and dynamic dns}
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency 'netaddr'
end
