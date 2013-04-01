# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_yubikey_database_authenticatable/version"

Gem::Specification.new do |s|
  s.name     = 'yubikey_database_authenticatable'
  s.version  = YubikeyDatabaseAuthenticatable::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary  = 'YubiKey OTP Authentication Plugin for Devise'
  s.description = 'Extended version of the Devise Database Authentication module to implement YubiKey OTP two factor authentication for registered users'
  s.email = 'mort666@virus.org'
  s.homepage = 'https://github.com/mort666/yubikey_database_authenticatable'
  s.description = s.summary
  s.authors = ['Stephen Kapp']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('devise', '~> 2.2.3')
  s.add_dependency('yubikey', '~> 1.3.1')
  s.add_development_dependency "active_support"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
end