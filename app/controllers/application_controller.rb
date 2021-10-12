class ApplicationController < ActionController::Base

    before_action :authorized
    helper_method :current_user
    helper_method :logged_in?
    helper_method :current_controller?

    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    end

    def logged_in?
        !current_user.nil?  
    end

    def authorized
        redirect_to '/login' unless logged_in?
    end

    def current_controller?(names)
      names.include?(params[:controller]) unless params[:controller].blank? || false
    end

end