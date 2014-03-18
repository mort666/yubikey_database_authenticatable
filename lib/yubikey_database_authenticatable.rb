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

  # Public: The api_url for a yubikey validation endpoint
  # If you're not using the Yubikey cloud, you'll need to set this. Otherwise,
  # the YubiKey gem will take care of it.
  # If you need this, set yubikey_api_url in the Devise configuration file
  # (config/initializers/devise.rb).
  #
  #   config.yubikey_api_url = "" # => API URL of verifier
  mattr_accessor :yubikey_api_url
  @@yubikey_api_url = nil

  # Public: The certificate_chain location for SSL validation
  # If you're using your own verifier (you've specified yubikey_api_url) it's
  # important that you pass the path to a verification chain for the CA or
  # other certificates involved. If you need this, set
  # yubikey_certificate_chain in the Devise configuration file
  # (config/initializers/devise.rb).
  #
  #   config.yubikey_certificate_chain = "" # => API Cert Chain File
  mattr_accessor :yubikey_certificate_chain
  @@yubikey_certificate_chain = nil
end

Devise.add_module(:yubikey_database_authenticatable, :strategy => true, :model => "devise_yubikey_database_authenticatable/model", :route => :session, :controller => :sessions)
