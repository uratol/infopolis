class Array
  def hash_key_value key_name,key_value,value_name
    h = self.detect{|x| x[key_name.to_s].to_s==key_value.to_s}
    h.nil? ? nil : h[value_name.to_s]
  end
end
