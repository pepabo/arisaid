class Hash
  alias_method :original_slice, :slice

  def slice(*keys)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end

  def stringify_keys
    result = self.class.new
    each_key { |k| result[k.to_s] = self[k] }
    result
  end

  def symbolize_keys
    self.map { |k,v| [k.to_sym, v] }.to_h
  end
end
