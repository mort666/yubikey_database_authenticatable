require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class YubikeyDatabaseAuthenticatable < Authenticatable
      def authenticate!
        resource = mapping.to.find_for_yubikey_database_authentication(authentication_hash)
        return fail(:not_found_in_database) unless resource

        if validate(resource)
          if resource.use_yubikey?
            fail('Yubikey OTP Required for this user.') if params[scope][:yubiotp].blank?
            
            if resource.validate_yubikey(params[scope][:yubiotp]) && (resource.registered_yubikey == params[scope][:yubiotp][0..11])
              resource.after_database_authentication
              success!(resource)
            else
              fail('Invalid Yubikey OTP.')
            end
          elsif resource.valid_password?(password)
            success!(resource)
          else
            fail(:invalid)
          end
        else
          fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:yubikey_database_authenticatable, Devise::Strategies::YubikeyDatabaseAuthenticatable)
