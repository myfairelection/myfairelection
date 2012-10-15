class PollingLocation
  # This model is designed to correspond to both "pollingLocation" and
  # "earlyVoteSite" objects from the Google API/VIP Feed
  attr_accessor :location_name, :address, :polling_hours, :name, :properties

  def initialize(pl_hash = {})
    @properties = {}
    pl_hash.keys.each do |key|
      case key
      when "address"
        @location_name = pl_hash["address"]["locationName"]
        @address = Address.new(pl_hash["address"])
      when "pollingHours"
        @polling_hours = pl_hash[key]
      when "name"
        @name = pl_hash[key]
      else
        @properties[key] = pl_hash[key]
      end
    end
  end
end
