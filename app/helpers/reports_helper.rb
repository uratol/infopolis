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

  def format_date(d)
    d.strftime('%d.%m.%Y') if d
  end

  def format_time(d)
    d.strftime('%H:%M') if d
  end

  def format_datetime(d)
    format_date(d)+' '+format_time(d) if d
  end
  
  def format_number(n, precision = 0)
    number_to_currency(n, unit: '', delimiter: ' ', precision: precision) if n
  end

end
