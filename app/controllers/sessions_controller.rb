class SessionsController < ApplicationController
  
  def new
    session[:return_to] = request.referer
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    user = User.find_by(name: params[:session][:email]) if user.nil?
    
    if user && user.authenticate(params[:session][:password])
      sign_in(user)
      #redirect_to root_path
      redirect_to session.delete(:return_to)
    else
      flash.now[:error] = 'Invalid email/password combination'
      #@session.email = params[:session][:email]
      @email_prev = params[:session][:email]
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
