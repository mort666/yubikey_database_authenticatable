require 'yubikey'
require 'bcrypt'

  module Devise
    module Models
      module YubikeyDatabaseAuthenticatable
        extend ActiveSupport::Concern
        
        included do
          attr_reader :yubiotp, :password, :current_password
          attr_accessor :password_confirmation
        end
        
        def validate_yubikey(yubiotp)
          begin
            if Devise.yubikey_api_url && Devise.yubikey_certificate_chain
              # If you've got your own API URL, you should have your own cert
              # chain, too. If not, you'll use the default one for Yubicloud
              # that is included in the Yubikey gem.
              otp = Yubikey::OTP::Verify.new(:otp => yubiotp, 
                                             :api_id => Devise.yubikey_api_id, 
                                             :api_key => Devise.yubikey_api_key,
                                             :url => Devise.yubikey_api_url, 
                                             :certificate_chain => :Devise.yubikey_certificate_chain)
            else
              otp = Yubikey::OTP::Verify.new(:otp => yubiotp, 
                                             :api_id => Devise.yubikey_api_id, 
                                             :api_key => Devise.yubikey_api_key)
            end
          
            if otp.valid?
              return true
            else
              return false
            end
          rescue Yubikey::OTP::InvalidOTPError 
            return false
          end
        end
        
        # Generates password encryption based on the given value.
              def password=(new_password)
                @password = new_password
                self.encrypted_password = password_digest(@password) if @password.present?
              end

              # Verifies whether an password (ie from sign in) is the user password.
              def valid_password?(password)
                return false if encrypted_password.blank?
                bcrypt   = ::BCrypt::Password.new(self.encrypted_password)
                password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
                Devise.secure_compare(password, self.encrypted_password)
              end

              # Set password and password confirmation to nil
              def clean_up_passwords
                self.password = self.password_confirmation = ""
              end

              # Update record attributes when :current_password matches, otherwise returns
              # error on :current_password. It also automatically rejects :password and
              # :password_confirmation if they are blank.
              def update_with_password(params={})
                current_password = params.delete(:current_password)

                if params[:password].blank?
                  params.delete(:password)
                  params.delete(:password_confirmation) if params[:password_confirmation].blank?
                end

                result = if valid_password?(current_password)
                  update_attributes(params)
                else
                  self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
                  self.attributes = params
                  false
                end

                clean_up_passwords
                result
              end

              def after_database_authentication
              end

              # A reliable way to expose the salt regardless of the implementation.
              def authenticatable_salt
                self.encrypted_password[0,29] if self.encrypted_password
              end

            protected

              # Downcase case-insensitive keys
              def downcase_keys
                (self.class.case_insensitive_keys || []).each { |k| self[k].try(:downcase!) }
              end

              # Digests the password using bcrypt.
              def password_digest(password)
                ::BCrypt::Password.create("#{password}#{self.class.pepper}", :cost => self.class.stretches).to_s
              end
        
        module ClassMethods
          def find_for_yubikey_database_authentication(conditions)
            find_for_authentication(conditions)
          end
        
          Devise::Models.config(self, :pepper, :stretches)
        end      
      end
      
    end
  end
