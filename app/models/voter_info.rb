require 'google-civic'
require 'ostruct'

class VoterInfo 
  APIKEY = Settings.google_api_key
  ELECTION_ID = Settings.google_election_id

  def self.lookup(address)
    VoterInfo.new(address)
  end

  def initialize(address)
    client = GoogleCivic.new(:key => APIKEY)
    @voter_info = client.voter_info(ELECTION_ID, address)
  end

  def normalized_address
    @voter_info.normalizedInput
  end

  def polling_places
    @voter_info.pollingLocations ? @voter_info.pollingLocations : []
  end

  def early_voting_places
    @voter_info.earlyVoteSites
  end
end
