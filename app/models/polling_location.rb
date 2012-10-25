class PollingLocation < ActiveRecord::Base
  attr_accessible :line1, :line2, :line3, :city, :state, :zip, :name, :location_name, :county, :latitude, :longitude, :properties
  validates :state, :format => { :with => /^[A-Z][A-Z]$/ }, :allow_nil => true
  validate :at_least_one_address_field_must_be_present
  serialize :properties, JSON
  ADDRESS_ATTRIBS = [:line1, :line2, :line3, :city, :state, :zip]
  STRING_ATTRIBS = ADDRESS_ATTRIBS + [:name, :location_name, :county]
  ATTRIBS = STRING_ATTRIBS + [:latitude, :longitude]
  belongs_to :feed

  # This model is designed to correspond to both "pollingLocation" and
  # "earlyVoteSite" objects from the Google API/VIP Feed

  STRING_ATTRIBS.each do |attrib|
    define_method "#{attrib}=" do |s|
      write_attribute(attrib, s.blank? ? nil : s)
    end
  end
  # state should always be all caps. 
  def state=(s)
    write_attribute(:state, s.blank? ? nil : s.upcase)
  end

  def at_least_one_address_field_must_be_present
    unless ADDRESS_ATTRIBS.inject(false) { |ret, field| ret || self.send(field) }
      errors[:base] << "At least one address field must be present"
    end
  end
  # Builds and saves a new PollingLocation using the JSON returned by the Google Civic Information API.
  # Sample:
  # {
  #      "address" => {
  #       "locationName" => "National Guard Armory",
  #       "line1" => "100 S 20th St",
  #       "city" => "Kansas City",
  #       "state" => "KS",
  #       "zip" => "66102 "
  #      },
  #      "pollingHours" => "8:00am to 8:00pm",
  #      "sources" => [
  #       {
  #        "name" => "Voting Information Project",
  #        "official" => "true"
  #       }
  #      ]
  #     }
  def PollingLocation.find_or_create_from_google!(location_hash)
    attribs = {:properties =>{}}
    location_hash.keys.each do |key|
      case key
      when "address"
        location_hash[key].keys.each do |addr_key|
          case addr_key
          when "locationName"
            attribs[:location_name] = location_hash[key][addr_key]
          else
            attribs[addr_key.to_sym] = location_hash[key][addr_key]
          end
        end
      when "name"
        attribs[key.to_sym] = location_hash[key]
      else
        attribs[:properties][key.to_sym] = location_hash[key]
      end
    end
    address = attribs.select {|k,v| ADDRESS_ATTRIBS.include?(k)}
    pl = PollingLocation.where(address).first
    if pl
      pl.update_attributes!(attribs)
      pl
    else
      PollingLocation.create!(attribs)
    end
  end

  def PollingLocation.update_or_create_from_xml!(node)
    nodes = node.xpath(".//*[count(*)=0]")
    attribs = {:properties => {}}
    nodes.each do |n|
      case n.name
      when "lat"
        attribs[:latitude] = n.text.to_f
      when "long"
        attribs[:longitude] = n.text.to_f
      else
        sym = n.name.to_sym
        if ATTRIBS.include?(sym)
          attribs[sym] = n.text
        else
          attribs[:properties][sym] = n.text
        end
      end
    end
    address = attribs.select {|k,v| ADDRESS_ATTRIBS.include?(k)}
    pl = PollingLocation.where(address).first
    if pl
      attribs.each do |k,v|
        pl.send("#{k}=",v)
      end
    else
      pl = PollingLocation.new(attribs)
    end
    if pl.valid?
      pl.save!
      pl
    else
      puts "Node #{node['id']} is invalid because:"
      pl.errors.to_a.each do |message|
        puts "    #{message}"
      end
      nil
    end
  end
end
