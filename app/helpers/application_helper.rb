module ApplicationHelper
  def full_title(page_title=nil)
    base_title = 'Infopolis'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def isnil(v, v_if_nil)
    v.nil? ? v_if_nil : v
  end
end
