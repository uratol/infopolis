class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User #{ user_full_name(@user) } registered"
      redirect_to '/'
      #redirect_to @user
    else
      flash[:error] = "User not registered"
      render 'new'
    end
  end
  
  def destroy
    user = User.find params[:id]
    flash[:success] = "User #{ user_full_name(user) } deleted" 
    user.destroy!
    redirect_to users_path
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    
    params[:user].delete(:password) if params[:user][:password].blank?
    
    #user_params.delete(:password) if params[:user][:password].blank?
    
    edit_params1 = user_params
    edit_params1.except! *[:password, :password_confirmation]  if user_params[:password].blank?
    
    flash[:debug] = edit_params1
    
    if @user.update_attributes(edit_params1)
      flash[:success] = "User #{ user_full_name(@user) } updated" 
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def user_full_name(user)
      "#{ user.name } <#{ user.email }>"
    end
end
