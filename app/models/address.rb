class Address
  attr_accessor :line1, :line2, :line3, :city, :state, :zip

  ATTRIBUTES = "line1", "line2", "line3", "city", "state", "zip"

  def initialize(addr = {})
    raise TypeError unless addr.is_a?(Hash)
    addr.keys.each do |key|
      self.instance_variable_set("@#{key}", addr[key]) if ATTRIBUTES.include?(key)
    end
  end

  def to_h
    ret = {}
    ATTRIBUTES.each do |key|
      ret[key] = self.send(key) unless self.send(key).nil?
    end
    ret
  end
end