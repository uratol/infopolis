class SessionsController < ApplicationController
  
=begin  
  class Session
    attr_accessor :name
  end
  
=end

  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    user = User.find_by(name: params[:session][:email]) if user.nil?
    
    if user && user.authenticate(params[:session][:password])
      sign_in(user)
      redirect_to root_path
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
