module ReportsHelper
  def format_money(m)
    number_to_currency(m, unit: '', delimiter: ' ')
  end
  def format_liters(m)
    number_to_currency(m, unit: '', delimiter: ' ')
  end
  
  def format_percent(m)
    number_to_currency(m, unit: '', delimiter: ' ', precision: 1)
  end
end
