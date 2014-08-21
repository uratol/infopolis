module ReportsHelper
  def format_money(m)
    number_to_currency(m, unit: '', delimiter: ' ')
  end
  def format_liters(m, precision = 2)
    number_to_currency(m, unit: '', delimiter: ' ', precision: precision)
  end
  
  def format_percent(m)
    number_to_currency(m, unit: '', delimiter: ' ', precision: 1)
  end

  def format_datetime(d)
    d.strftime('%d-%m-%Y %H:%M') if d
  end
  
  def format_number(n, precision = 0)
    number_to_currency(n, unit: '', delimiter: ' ', precision: precision) if n
  end

end
