class Guest

  attr_accessor :email, :first_name, :last_name

  def initialize
    super
    @email = 'guest@plugh.com'
    @first_name = 'Guest'
    @last_name = 'User'
  end

  #def has_role? name
  #  name.to_sym == :guest
  #end

  def roles_list
    []
  end

  def role_groups_list
    []
  end
end