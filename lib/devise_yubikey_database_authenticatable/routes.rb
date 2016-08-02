ActionDispatch::Routing::Mapper.class_eval do
  protected
  alias_method :devise_yubikey_database_authenticatable, :devise_session
end
