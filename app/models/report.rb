class Report < ActiveRecord::Base
  
  establish_connection "mssql_#{Rails.env}"
  
  attr_accessor :name, :caption

  def self.initialize(name, caption)
    super
    @name = name
    @caption = caption
  end

  def self.first
    all.first
  end
  
  def self.find_by_name(name)
    all.find { |e| e.name.to_s==name }
  end
  

  def self.all
    unless @reports
      @reports = Array.new << Report.new(name: :sales, caption: "Sales") << Report.new(name: :counters, caption: "Counters")  <<  Report.new(name: :tank, caption: "Tanks")
    end  
    @reports
  end
end
