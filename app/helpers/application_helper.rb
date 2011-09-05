module ApplicationHelper
  def current_user_name
    "#{current_user.first_name} #{current_user.last_name}"
  end
end
