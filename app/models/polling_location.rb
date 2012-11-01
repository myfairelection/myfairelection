class PollingLocation < ActiveRecord::Base
  attr_accessible :early_vote, :line1, :line2, :line3, :city, :state, :zip, 
                  :name, :location_name, :county, :latitude, :longitude, :properties
  validates :state, :format => { :with => /^[A-Z][A-Z]$/ }, :allow_nil => true
  validates :zip, :format => { :with => /^\d{5}(-\d{4})?$/ }, :allow_nil => true
  validate :at_least_one_address_field_must_be_present
  serialize :properties, JSON
  ADDRESS_ATTRIBS = [:line1, :line2, :line3, :city, :state, :zip]
  STRING_ATTRIBS = ADDRESS_ATTRIBS + [:name, :location_name, :county]
  ATTRIBS = STRING_ATTRIBS + [:latitude, :longitude]
  belongs_to :feed
  has_many :reviews

  # This model is designed to correspond to both "pollingLocation" and
  # "earlyVoteSite" objects from the Google API/VIP Feed

  STRING_ATTRIBS.each do |attrib|
    define_method "#{attrib}=" do |s|
      write_attribute(attrib, s.blank? ? nil : s)
    end
  end
  # state should always be all caps. 
  def state=(s)
    write_attribute(:state, PollingLocation.normalize_state(s))
  end
  def zip=(s)
    write_attribute(:zip, PollingLocation.normalize_zip(s))
  end

  def self.normalize_zip(zip)
    return nil if zip.blank?
    zip.strip!
    case zip
    when /^(\d{5})(\d{4})$/
      "#{$1}-#{$2}"
    when /^(\d{5})-$/
      "#{$1}"
    else
      zip    
    end
  end

  def self.normalize_state(state)
    state.blank? ? nil : state.upcase[0..1]
  end

  def at_least_one_address_field_must_be_present
    unless ADDRESS_ATTRIBS.inject(false) { |ret, field| ret || self.send(field) }
      errors[:base] << "At least one address field must be present"
    end
  end

  def self.find_by_address(address)
    search = ADDRESS_ATTRIBS.inject({}) do |result, attrib| 
      case 
      when address[attrib].blank?
        result[attrib] = nil
      when attrib == :zip
        result[attrib] = self.normalize_zip(address[attrib])
      when attrib == :state
        result[attrib] = self.normalize_state(address[attrib])
      else
        result[attrib] = address[attrib]
      end
      result
    end
    search[:early_vote] = address[:early_vote] ? true : false
    self.where(search).first
  end

  def PollingLocation.update_or_create_from_attribs_and_properties(attribs, properties)
    pl = PollingLocation.find_by_address(attribs)
    if pl
      pl.update_attributes!(attribs)
      pl.properties = pl.properties.merge(properties)
      pl.save!
      pl
    else
      attribs[:properties] = properties
      PollingLocation.create!(attribs)
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
  def PollingLocation.find_or_create_from_google!(location_hash, early_vote = false)
    attribs = {}
    properties = {}
    location_hash.keys.each do |key|
      case key
      when "address"
        location_hash[key].keys.each do |addr_key|
          case addr_key
          when "locationName"
            attribs[:location_name] = location_hash[key][addr_key].strip
          else
            attribs[addr_key.to_sym] = location_hash[key][addr_key].strip
          end
        end
      when "name"
        attribs[key.to_sym] = location_hash[key].strip
      else
        properties[key.to_sym] = location_hash[key]
      end
    end
    attribs[:early_vote] = early_vote
    update_or_create_from_attribs_and_properties(attribs, properties)
  end

  class Reader
    attr_accessor :attributes, :properties, :reader

    def initialize(reader)
      @reader = reader
      @attributes = {}
      @properties = {}
      @elements = []
      @values = []
    end

    def parse
      begin        
        case @reader.node_type
        when Nokogiri::XML::Reader::TYPE_ELEMENT
          unless @reader.self_closing?
            @elements.unshift(@reader.name)
            @values.unshift('')
          end
        when Nokogiri::XML::Reader::TYPE_END_ELEMENT
          save_value(@elements[0].to_sym, @values[0])
          @elements.shift
          @values.shift
        when Nokogiri::XML::Reader::TYPE_TEXT
          @values[0] << @reader.value 
        else
          # do nothing
        end
        @reader.read
      end until @elements.length == 0
    end

    def save_value(name, value)
      if name == :early_vote_site
        @attributes[:early_vote] = true
      end
      return if value.blank?
      case
      when name == :locationName
        @attributes[:location_name] = value
      when name == :lat
        @attributes[:latitude] = value
      when name == :long
        @attributes[:longitude] = value
      when ATTRIBS.include?(name.to_sym)
        @attributes[name.to_sym] = value
      else
        @properties[name.to_sym] = value  
      end
    end
  end

  # Expects a Nokogiri::XML::Reader or equivalent, with the cursor positioned at
  # the first polling_location (or early_vote_location) element.
  def PollingLocation.update_or_create_from_xml!(reader)
    id = reader.attribute("id")
    r = Reader.new(reader)
    r.parse
    begin
      update_or_create_from_attribs_and_properties(r.attributes, r.properties)
    rescue ActiveRecord::RecordInvalid => err
      puts "Location #{id} is invalid: "
      err.record.errors.each do |attr, error|
        puts "  #{attr}: #{err.record.read_attribute(attr)} #{error}"
      end
      return nil
    end
  end
end
