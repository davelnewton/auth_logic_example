class User < ActiveRecord::Base

  tango_user

  attr_accessible :first_name, :last_name, :email, :nickname, :password, :user_session

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true

  # NOTE The authlogic validation already puts its errors in the right place.
  #validates :password, :presence => true

  acts_as_authentic do |c|
    c.login_field = :email
    c.validate_login_field = false
    c.require_password_confirmation = false
  end

  def roles_list
    (self.email.ends_with? "gmail.com") ? [:user] : []
  end

  def has_role? name
    roles_list.contains name.to_sym
  end

  def role_groups_list
    []
  end

  class << self
    # TODO Any risk in allowing emails as nicknames?
    # Might want to disallow using someone else's email address.
    def find_by_nickname_or_email(s)
      find_by_nickname(s) || find_by_email(s)
    end
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  first_name         :string(255)
#  last_name          :string(255)
#  nickname           :string(255)
#
