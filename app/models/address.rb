class Address
  attr_accessor :line1, :line2, :line3, :city, :state, :zip

  ATTRIBUTES = 'line1', 'line2', 'line3', 'city', 'state', 'zip'

  def initialize(addr = {})
    return if addr.nil?
    fail TypeError unless addr.is_a?(Hash)
    addr.keys.each do |key|
      send("#{key}=", addr[key]) if ATTRIBUTES.include?(key)
    end
  end

  def state=(s)
    @state = s.upcase
  end

  def to_h
    ret = {}
    ATTRIBUTES.each do |key|
      ret[key] = send(key) unless send(key).nil?
    end
    ret
  end

  def blank?
    ATTRIBUTES.inject(true) { |result, attrib| result && send(attrib).blank? }
  end

  def to_s
    ret = ''
    ret << "#{line1}\n" if line1
    ret << "#{line2}\n" if line2
    ret << "#{line3}\n" if line3
    ret << "#{city}, #{state} #{zip}\n"
    ret
  end
end
