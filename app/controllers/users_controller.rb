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
    if !user.destroy
      flash[:danger] = user.errors.full_messages.join
    end
    
    redirect_to users_path
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def masters
    @user = User.find params[:id]
    if params[:masters] && !@user.admin
      ActiveRecord::Base.transaction do
        #flash[:info] = params[:masters]
        params[:masters].each do |master_id, h|
          if h['access']=='1'
            @user.user_masters.create(master_id: master_id) unless @user.master_access(master_id)
          else  
            UserMaster.destroy_all("user_id=#{@user.id} and master_id=#{master_id}")
          end
        end
      end
      redirect_to users_path
    end  
    #render root_path
    @all_masters = Master.all
  end  
  
  def update
    @user = User.find params[:id]
    
    edit_params = user_params
    edit_params.except! :password, :password_confirmation  if user_params[:password].blank?
    
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
