# Devise - Yubikey Database Authentication

This extension to Devise adds a modified Database Authentication strategy to allow the authentication of a user with Two Factor Authentication provided by the Yubikey OTP token

This extension requires the used to already have a valid account and password and verifies that the user exists along with the password provided by verifying that the user presented a valid Yubikey OTP.

## Installation

This plugin requires Rails 3.0.x and 3.1.x and Devise 1.3.4+. Additionally the Yubikey Ruby library found here is required.

<https://github.com/titanous/yubikey>

The gem for the Yubikey library will need to be added to your Gemfile. To install the plugin add this plugin to your Gemfile.

	gem 'yubikey_database_authenticatable'

## Setup

Once the plugin is installed, all you need to do is setup the user model which includes a small addition to the model itself and to the schema.

The following needs to be added to the User module.

	add_column :users, :use_yubikey, :boolean
	add_column :users, :registered_yubikey, :string

then finally add to the model:

	class User < ActiveRecord::Base

      devise :yubikey_database_authenticatable, :trackable, :timeoutable

      # Setup accessible (or protected) attributes for your model
      attr_accessible :use_yubikey, :registered_yubikey, :yubiotp

	  attr_accessor :yubiotp
		
	  def registered_yubikey=(yubiotp)
	    write_attribute(:registered_yubikey, yubiotp[0..11])
	  end
	
      ...
	end

## Copyright

Copyright (c) 2011 Stephen Kapp, Released under MIT License
