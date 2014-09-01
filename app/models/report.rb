class Report < ActiveRecord::Base
  
  establish_connection "mssql_#{Rails.env}"
  
  attr_accessor :id, :name, :caption, :daterange, :filters

  before_create :set_defaults

  def self.initialize(id, name, caption, filters = [])
    super
    @id = id
    @name = name
    @caption = caption
    @filters = filters || []
  end
  

  def self.first
    all.first
  end
  
  def self.find_by_name(name)
    all.find { |e| e.name.to_s==name }
  end
  

  def self.all
    unless @reports
      @reports = Array.new 
      @reports << Report.new(id: 1, name: :sales, caption: "Sales", filters: [:daterange]) 
      @reports << Report.new(id: 2, name: :counters, caption: "Counters", filters: [:daterange])  
      @reports <<  Report.new(id: 3, name: :tanks, caption: "Tanks", filters: [])
      @reports <<  Report.new(id: 4, name: :prices, caption: "Prices", filters: [])
      @reports <<  Report.new(id: 5, name: :sync, caption: "Data sync", filters: [])
    end  
    @reports
  end
  
  def dt_from
    @daterange[0..9]
  end

  def dt_to
    @daterange[-10..-1]
  end
  
  private
    def set_defaults
      @daterange = '2014-08-18 - 2014-08-18'
    end
end
