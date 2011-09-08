module ApplicationHelper
  def current_user_name
    "#{current_user.first_name} #{current_user.last_name}"
  end

  def login_logout_link
    is_guest? ? link_to("Sign in", login_path) : link_to("Sign out #{current_user.first_name}", logout_path)
  end

end
