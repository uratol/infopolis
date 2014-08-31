class ReportsController < ApplicationController
  include SessionsHelper

  before_action :require_signin
  
  def index

    @masters = Master.all
    @master = @masters.find_by_id(params[:master]) || @masters.first

    @reports = Report.all
    
    
    @report = @reports.find{|r| r.name.to_s==params[:report_name]} || @reports.first
    
    begin
      
      Time::DATE_FORMATS[:input_date] = "%Y-%m-%d"
      today_str = Time.current.to_s :input_date
      @report.daterange = "#{today_str} : #{today_str}" unless @report.daterange

      if reports_params
        @report.attributes = reports_params
      end 
      
      procedure_params = {report_name: @report.name, user: current_user.name}
      if @report.filters.include?(:daterange)
        procedure_params.merge! dt_from: @report.dt_from, dt_to: @report.dt_to
      end
      
      if params[:data]
        procedure_params.merge! data: params[:data]
      end
      
      @report_data = Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{@report.name.upcase}", procedure_params 
      
      send @report.name if respond_to? @report.name

      #@report.xml = (Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{@report.name.upcase}", {@report.name: @report.name, user: current_user.name, dt_from: @report.dt_from, dt_to: @report.dt_to} ).first.values.join

    rescue Exception => e
      flash.now[:danger] = e
    end

  end
  
  def sales
    @report_masts, @report_fopls, @report_data = @report_data
    def @report_masts.bmast_nm (bmast_id)
      find{|m| m['bmast_id']==bmast_id}['bmast_nm']
    end  
  end
  
  def tanks
    @report_data, @tank_values = @report_data
  end

  def prices
    @report_masts, @report_tovs, @report_data = @report_data
  end
  
  
  private
    def reports_params
      if params
        report_par = params[:report]
        report_par.permit(:daterange) if report_par
      end
    end

end
