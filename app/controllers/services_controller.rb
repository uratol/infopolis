class ServicesController < ApplicationController
  def index
  end
  
 
  def create
    
omniauth = request.env['omniauth.auth']
render :text => omniauth.inspect #omniauth 


     
=begin    
    omniauth = request.env['omniauth.auth']['extra']['user_hash']
    email = omniauth['email']
    
    user = User.find_by(email: email.downcase)
    
    if !user 
      user = User.create(name: omniauth['name'], email: email)
      sign_in(user)
      flash[:error] = "User registered from #{ params[:service] }"
    end    
    sign_in(user)
    redirect_to session.delete(:return_to)
=end
  end
  
end