require 'ostruct'

class VoterInfo
  APIKEY = Settings.google_api_key
  ELECTION_ID = Settings.google_election_id

  def self.lookup(address)
    VoterInfo.new(address)
  end

  def initialize(address)
    response = RestClient.post 'https://www.googleapis.com/' \
                               "civicinfo/us_v1/voterinfo/#{ELECTION_ID}/" \
                               "lookup?key=#{APIKEY}",
                               { 'address' => address }.to_json,
                               content_type: :json, accept: :json
    @response = ActiveSupport::JSON.decode(response)
  end

  def status
    @status ||= @response['status']
  end

  def normalized_address
    @normalized_address ||= if @response['normalizedInput']
                              Address.new(@response['normalizedInput'])
                            else
                              nil
                            end
  end

  def polling_locations
    if @polling_locations
      @polling_locations
    else
      locations = @response['pollingLocations']
      if locations
        @polling_locations = locations.map do |e|
          PollingLocation.find_or_create_from_google!(e, false)
        end
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
      evplaces = @response['earlyVoteSites']
      if evplaces
        @early_voting_places = evplaces.map do |e|
          PollingLocation.find_or_create_from_google!(e, true)
        end
      else
        @early_voting_places = []
      end
      @early_voting_places
    end
  end
end
