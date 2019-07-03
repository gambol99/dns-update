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
  s.files       = [ '.gitignore', 'Gemfile', 'LICENSE', 'README.md', 'bin/.config.yaml',
			'bin/dns', 'dns-update.gemspec', 'lib/dns-update.rb', 'lib/dns-update/dns.rb',
			'lib/dns-update/error.rb', 'lib/dns-update/model.rb', 'lib/dns-update/nsupdate.rb',
		       	'lib/dns-update/settings.rb', 'lib/dns-update/utils.rb', 'lib/dns-update/validate.rb',
			'lib/dns-update/version.rb', 'tests/test.rb']
  s.test_files  = [ 'tests/test.rb' ]
  s.executables = [ 'dns' ]
  s.add_dependency 'netaddr'
end
