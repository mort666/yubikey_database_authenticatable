# YubikeyDatabaseAuthenticatable

require 'devise'

$: << File.expand_path("..", __FILE__)

require 'devise_yubikey_database_authenticatable/model'
require 'devise_yubikey_database_authenticatable/strategy'
require 'devise_yubikey_database_authenticatable/routes'

Devise.add_module(:yubikey_database_authenticatable, :strategy => true, :model => "devise_yubikey_database_authenticatable/model", :route => true)