class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Login info is invalid!"
  find_by_login_method :find_by_nickname_or_email
end
