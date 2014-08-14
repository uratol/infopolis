class SessionsController < ApplicationController
  
  def new
    session[:return_to] = request.referer
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) || User.find_by(name: params[:session][:email])
    
    if user && user.authenticate(params[:session][:password])
      sign_in(user, params[:session][:remember]=='1' )
      redirect_to session.delete(:return_to) || root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      #@session.email = params[:session][:email]
      @email_prev = params[:session][:email]
      @remember_prev = params[:session][:remember]
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
