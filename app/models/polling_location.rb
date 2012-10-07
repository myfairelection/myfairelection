class PollingLocation < ActiveRecord::Base
  attr_accessible :line1, :line2, :line3, :city, :state, :zip, :name, :location_name,  :county, :latitude, :longitude, :properties
  validates_presence_of :line1, :city, :state
  validates :state, :format => { :with => /^[A-Z][A-Z]$/ }
  serialize :properties, JSON
  UNIQUE_ATTRIBS = [:line1, :line2, :line3, :city, :state, :zip]
  # This model is designed to correspond to both "pollingLocation" and
  # "earlyVoteSite" objects from the Google API/VIP Feed

  # state should always be all caps. 
  def state=(s)
    write_attribute(:state, s ? s.upcase : nil)
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
    address = attribs.select {|k,v| UNIQUE_ATTRIBS.include?(k)}
    pl = PollingLocation.where(address).first
    if pl
      pl.update_attributes!(attribs)
      pl
    else
      PollingLocation.create!(attribs)
    end
  end
  attr_accessible :address, :feed_id, :id_attribute, :properties
  validates_presence_of :id_attribute, :properties, :address, :feed_id
  serialize :address, Hash
  serialize :properties, Hash
end
