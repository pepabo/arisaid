class Array
  def find_by(name: nil, id: nil)
    if name
      self.find { |v| v['name'] == name }
    elsif id
      self.find { |v| v['id'] == id }
    else
      self
    end
  end
end

