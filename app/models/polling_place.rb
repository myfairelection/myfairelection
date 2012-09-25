require 'rest_client'

class PollingPlace
  APIKEY = Settings.google_api_key
  def self.lookup(address)
    PollingPlace.new(address)
  end

  def initialize(address)
    response = RestClient.post "https://www.googleapis.com/civicinfo/us_v1/voterinfo/2000/lookup?key=#{APIKEY}",
          { "address" => address }.to_json, :content_type => :json, :accept => :json
    @response = ActiveSupport::JSON.decode(response)
  end

  def response
    @response
  end
  # parsed_json = ActiveSupport::JSON.decode(your_json_string)

  def name
    @response["pollingLocations"][0]["address"]["locationName"]
  end

  def street
    @response["pollingLocations"][0]["address"]["line1"]
  end

  def city
    @response["pollingLocations"][0]["address"]["city"]
  end

  def state
    @response["pollingLocations"][0]["address"]["state"]
  end

  def zip
    @response["pollingLocations"][0]["address"]["zip"]
  end


  def hours
    @response["pollingLocations"][0]["pollingHours"]
  end
end