class ReportsController < ApplicationController
  include SessionsHelper

  before_action :require_signin
  
  def index
    @reports = Report.all
    @masters = Master.all

    report_name = params[:report_name]
    master_id = params[:master]

    @master = @masters.find_by_id(master_id) || @masters.first
    @report = Report.find_by_name(report_name) || @reports.first
    
    if report_name && master_id
      begin
        
        Time::DATE_FORMATS[:input_date] = "%Y-%m-%d"
        today_str = Time.current.to_s :input_date
        @report.daterange = "#{today_str} : #{today_str}" unless @report.daterange

        if reports_params
          @report.attributes = reports_params
        end 
        
        procedure_params = {report_name: report_name, user: current_user.name}
        if @report.filters.include?(:daterange)
          procedure_params.merge! dt_from: @report.dt_from, dt_to: @report.dt_to
        end
        
        @report_data = Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{report_name.upcase}", procedure_params 
        
        send @report.name if respond_to? @report.name

        #@report.xml = (Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{report_name.upcase}", {report_name: report_name, user: current_user.name, dt_from: @report.dt_from, dt_to: @report.dt_to} ).first.values.join

      rescue Exception => e
        flash.now[:danger] = e
      end

    else
      redirect_to "/reports/#{@report.name}/#{@master.id}"
    end
  end
  
  def sales
    @report_masts, @report_fopls, @report_data = @report_data
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
