require 'spec_helper'

describe VoterInfo do
  context "with a valid address without poll information" do
    before(:each) do  
      RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/white_house.json").read)
    end
    let (:vi) { VoterInfo.lookup("DC") }
    it "has a normalized version of the address" do
      vi.normalized_address.city.should eq 'Washington'
    end
    it "has an empty array of polling places" do
      vi.polling_places.should eq []
    end
  end
  context "with a valid address with poll information" do
    before(:each) do  
      RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/ks_response.json").read)
    end
    let (:vi) { VoterInfo.lookup("KS") }
    it "has a normalized version of the address" do
      vi.normalized_address.city.should eq 'Kansas City'
    end
    it "has a polling place" do
      vi.polling_places.length.should be > 0
    end
    it "has early voting information" do
      vi.early_voting_places.length.should be > 0
    end
  end
end