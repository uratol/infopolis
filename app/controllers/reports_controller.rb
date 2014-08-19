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
        
        @results = Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{report_name.upcase}", {report_name: report_name, user: current_user.name, dt_from: @report.dt_from, dt_to: @report.dt_to}
        
        if respond_to? @report.name # && %w[foo bar].include?(method_name)
          send @report.name
        end 

        #@report.xml = (Report.execute_procedure "#{@master.database}.web.NAFTAPOS_#{report_name.upcase}", {report_name: report_name, user: current_user.name, dt_from: @report.dt_from, dt_to: @report.dt_to} ).first.values.join

      rescue Exception => e
        flash.now[:danger] = e
      end

    #      @report_html = %+<div class="alert-info">report:#{ @report.name }; master: #{@master.name}</div>+

    else
      redirect_to "/reports/#{@report.name}/#{@master.id}"
    end
  end
  
  def sales
    @report_masts, @report_fopls, @report_tovs = @results
  end
  
  private
    def reports_params
      if params
        report_par = params[:report]
        report_par.permit(:daterange) if report_par
      end
    end

end
