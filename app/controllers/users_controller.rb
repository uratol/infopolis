class UsersController < ApplicationController
  
  include SessionsHelper
  
  before_action :require_admin
  
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
      redirect_to users_path
      #redirect_to @user
    else
      flash.now[:danger] = "User not registered"
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
    
    edit_params = user_params
    edit_params.except! *[:password, :password_confirmation]  if user_params[:password].blank?
    
    if @user.update_attributes(edit_params)
      flash[:success] = "User #{ user_full_name(@user) } updated" 
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
    
    def user_full_name(user)
      "#{ user.name } <#{ user.email }>"
    end
    
end
