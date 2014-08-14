class MastersController < ApplicationController

  include SessionsHelper

  before_action :require_admin
  
  def index
    @masters = Master.all
  end 
  
  def new
    @master = Master.new
  end
  
  def edit
    @master = Master.find params[:id]
  end
  
  def update
    @master = Master.find params[:id]
    if @master.update_attributes master_params
      redirect_to masters_path
    else
      render 'edit'
    end
    
  end

  def create
    @master = Master.new(master_params)
    if @master.save
      redirect_to masters_path 
    else
      render 'new'  
    end
  end
  
  def destroy
    master = Master.find params[:id]
    master.destroy!
    redirect_to masters_path
  end  

  private
    def master_params
      params.require(:master).permit(:name, :database)
    end

end
