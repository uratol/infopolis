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
      begin
        xml = (Report.execute_procedure "#{@master.database}.web.#{report_name.upcase}_NAFTAPOS", {report_name: report_name, user: current_user.name} ).first.values.join
        noc_doc = Nokogiri::XML xml
        noc_xslt = Nokogiri::XSLT File.read("./public/#{report_name}_report.xsl")

        @report_html = noc_xslt.transform(noc_doc)
      rescue Exception => e
        flash.now[:danger] = e
      end

    #      @report_html = %+<div class="alert-info">report:#{ @report.name }; master: #{@master.name}</div>+

    else
      redirect_to "/reports/#{@report.name}/#{@master.id}"
    end
  end
end
