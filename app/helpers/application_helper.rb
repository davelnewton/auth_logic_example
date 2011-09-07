module ApplicationHelper
  def current_user_name
    "#{current_user.first_name} #{current_user.last_name}"
  end

  def login_logout_link
    current_user ? link_to("Log out", logout_path) : link_to("Log in", login_path)
  end

end
