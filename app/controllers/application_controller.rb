class ApplicationController < ActionController::Base
  protect_from_forgery
	
	# a better page when an access denied exception is raised
	rescue_from CanCan::AccessDenied do |exception|
	  flash[:error] = "You do not have access to this page."
	  redirect_to home_path
	end

  private
	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def logged_in?
	  current_user
	end
	helper_method :logged_in?

	def check_login
		if(current_user.nil?)
			flash[:error] = "You need to log in to view this page."
		  redirect_to login_url
		end
	end
end
