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
  
  def array_hash_key_value(a,key_name,key_value,value_name,isnil_value = 0)
    h = a.detect{|x| x[key_name.to_s].to_s==key_value.to_s}
    isnil(h.nil? ? nil : h[value_name.to_s] , isnil_value)
    #isnil(isnil(a.detect{|x| x[key_name]==key_value},{})[value_name], isnil_value)
  end 
  
end
