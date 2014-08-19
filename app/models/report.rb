class Report < ActiveRecord::Base
  
  establish_connection "mssql_#{Rails.env}"
  
  attr_accessor :id, :name, :caption, :daterange, :xml

  before_create :set_defaults

  def self.initialize(id, name, caption)
    super
    @id = id
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
      @reports = Array.new << Report.new(id: 1, name: :sales, caption: "Sales") << Report.new(id: 2, name: :counters, caption: "Counters")  <<  Report.new(id: 3, name: :tanks, caption: "Tanks")
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
