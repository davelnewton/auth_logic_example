class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
    c.require_password_confirmation = false
  end
end
