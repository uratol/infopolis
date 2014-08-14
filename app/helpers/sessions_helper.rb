module SessionsHelper

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def sign_in(user,remember)
    remember_token = User.new_remember_token
    if remember
      cookies.permanent[:remember_token] = remember_token
    else
      cookies[:remember_token] = remember_token
    end    
    
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def signed_admin?
    signed_in? && current_user.admin? 
  end
  
  def require_admin
    unless signed_admin?
      flash[:danger] = "You must be logged in as Admin to access this action"
      redirect_to signin_path
    end
  end

  def require_signin
    unless signed_in?
      flash[:danger] = "You must be logged in to access this action"
      redirect_to signin_path
    end
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end
