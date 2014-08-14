class ReportsController < ApplicationController
  include SessionsHelper
  
  before_action :require_signin

  def index
    @reports = Report.all
    @masters = Master.all
    
    report_name = params[:report_name]
    master_id = params[:master]

    @master = @masters.find_by_id(master_id) || @masters.first
    @report =  Report.find_by_name(report_name) || @reports.first
    
    if report_name && master_id
=begin      
      xml = (Report.execute_procedure "WEB_SALES_NAFTAPOS", {report: report_name} ).first.values.join
#      xml = (Report.execute_procedure "#{@master.database}..WEB_SALES_NAFTAPOS", {report: report_name} ).first.values.join
      xslt = (Report.execute_procedure :G_ENT_FILE, FileName: "web_naftapos.xsl").first[:data]
    
      noc_doc = Nokogiri::XML(xml)
      noc_xslt = Nokogiri::XSLT(xslt)
    
      @report_html = noc_xslt.transform(noc_doc)
=end 
      @report_html = %+<div class="alert-info">report:#{ @report.name }; master: #{@master.name}</div>+

    else
      redirect_to "/reports/#{@report.name}/#{@master.id}"
    end   
  end
end
