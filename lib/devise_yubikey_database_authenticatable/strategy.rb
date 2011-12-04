require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class YubikeyDatabaseAuthenticatable < Authenticatable
      def authenticate!
        resource = valid_password? && mapping.to.find_for_yubikey_database_authentication(authentication_hash)
    
        if validate(resource) {resource.valid_password?(password)}
          if resource.useyubikey == true
            if params[:user][:yubiotp].blank?
              fail('Yubikey OTP Required for this user.') 
            else
              if resource.validate_yubikey(params[:user][:yubiotp]) && (resource.registeredyubikey == params[:user][:yubiotp][0..11])
                resource.after_database_authentication
                success!(resource)
              else
                fail('Invalid Yubikey OTP.')
              end
            end
          else
            success!(resource)
          end
        else
          fail(:invalid)
        end
      end
    end
  end
end

  Warden::Strategies.add(:yubikey_database_authenticatable, Devise::Strategies::YubikeyDatabaseAuthenticatable)