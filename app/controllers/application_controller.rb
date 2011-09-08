class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :current_user_session, :current_user, :is_guest?

  protected

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def is_guest?
      logger.debug "-=> #{@current_user} #{@current_user.class}"
      @current_user = Guest.new if current_user.nil?
      @current_user.class == Guest || @current_user.class == NilClass
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_url
        return false
      end
    end

    alias_method :no_user_required, :require_no_user
    alias_method :user_required, :require_user

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
