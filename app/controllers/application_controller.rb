class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  def home
  end

  def require_admin
    unless signed_admin?
      flash[:danger] = "You must be logged in as Admin to access this action"
      redirect_to signin_path
    end
  end

end
