# YubikeyDatabaseAuthenticatable

require 'devise'

$: << File.expand_path("..", __FILE__)

require 'devise_yubikey_database_authenticatable/model'
require 'devise_yubikey_database_authenticatable/strategy'
require 'devise_yubikey_database_authenticatable/routes'

module Devise
  # Public: The api_key for a yubikey validation
  # Get a key here: https://upgrade.yubico.com/getapikey/
  # Set yubikey_api_key in the Devise configuration file (in config/initializers/devise.rb).
  #
  #   config.yubikey_api_key = "" # => Api Key must be set to validate one time passwords
  mattr_accessor :yubikey_api_key
  @@yubikey_api_key = nil

  # Public: The api_id for a yubikey validation
  # Get a key here: https://upgrade.yubico.com/getapikey/
  # Set yubikey_api_id in the Devise configuration file (in config/initializers/devise.rb).
  #
  #   config.yubikey_api_id = "" # => Api ID must be set to validate one time passwords
  mattr_accessor :yubikey_api_id
  @@yubikey_api_id = nil
end

Devise.add_module(:yubikey_database_authenticatable, :strategy => true, :model => "devise_yubikey_database_authenticatable/model", :route => :session, :controller => :sessions)
