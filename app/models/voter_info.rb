require 'ostruct'

class VoterInfo 
  APIKEY = Settings.google_api_key
  ELECTION_ID = Settings.google_election_id

  def self.lookup(address)
    VoterInfo.new(address)
  end

  def initialize(address)
    response = RestClient.post "https://www.googleapis.com/civicinfo/us_v1/voterinfo/#{ELECTION_ID}/lookup?key=#{APIKEY}",
          { "address" => address }.to_json, :content_type => :json, :accept => :json
    @response = ActiveSupport::JSON.decode(response)
  end

  def status
    @status ||= @response["status"]
  end

  def normalized_address
    @normalized_address ||= Address.new(@response["normalizedInput"])
  end

  def polling_locations
    if @polling_locations
      @polling_locations
    else
      locations = @response["pollingLocations"]
      if locations
        @polling_locations = locations.map { |e| PollingLocation.new(e) }
      else
        @polling_locations = []
      end
      @polling_locations
    end
  end

  def early_voting_places
    if @early_voting_places
      @early_voting_places
    else
      evplaces = @response["earlyVoteSites"]
      if evplaces
        @early_voting_places = evplaces.map { |e| PollingLocation.new(e) }
      else
        @early_voting_places = []
      end
      @early_voting_places
    end
  end
end
