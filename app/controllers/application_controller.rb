class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prepare_new_session
  helper_method :current_user_session, :current_user

  class UserLevel
    ADMIN = 1
    USER = 2
    FRIEND = 3
    GUEST = 4
    PUBLIC = 5
  end

  private

    def prepare_new_session
      @user_session = UserSession.new if current_user.blank?
    end

    def current_user_session
      logger.debug "ApplicationController::current_user_session"
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      logger.debug "ApplicationController::current_user"
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      logger.debug "ApplicationController::require_user"
      unless current_user
        #store_location
        #redirect_to new_user_session_url
        redirect_to root_path
        return false
      end
    end

    def require_no_user
      logger.debug "ApplicationController:require_no_user"
      if current_user
        #store_location
        redirect_to root_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end
