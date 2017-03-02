require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class YubikeyDatabaseAuthenticatable < Authenticatable
      def authenticate!
        resource = mapping.to.find_for_yubikey_database_authentication(authentication_hash)
        return fail(:not_found_in_database) unless resource
        
        valid_password, valid_yubikey = valid_password?(resource), valid_yubikey?(resource)
        
        if validate(resource) { valid_password and valid_yubikey }
          remember_me(resource)
          resource.after_database_authentication
          success!(resource)
        end
        
        # failure modes
        if not valid_password
          fail(:invalid)
        elsif not valid_yubikey
          if params[scope][:yubiotp].blank?
            fail('Yubikey OTP Required for this user.')
          else
            fail('Invalid Yubikey OTP.')
          end
        else
          false # reason lies elsewhere, continue to run
        end
      end
      
      protected
      def valid_yubikey?(resource)
        !resource.use_yubikey? or params[scope][:yubiotp].present? &&
          resource.validate_yubikey(params[scope][:yubiotp]) && (resource.registered_yubikey == params[scope][:yubiotp][0..11])
      end
      
      def valid_password?(resource)
        resource.valid_password?(password)
      end
    end
  end
end

Warden::Strategies.add(:yubikey_database_authenticatable, Devise::Strategies::YubikeyDatabaseAuthenticatable)
