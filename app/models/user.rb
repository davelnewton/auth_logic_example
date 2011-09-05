class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field = :email
    c.validate_login_field = false
    c.require_password_confirmation = false
  end

  class << self
    # TODO Any risk in allowing emails as nicknames?
    # Might want to disallow using someone else's email address.
    def find_by_nickname_or_email(s)
      find_by_nickname(s) || find_by_email(s)
    end
  end
  
end
