require 'spec_helper'

describe VoterInfo do
  context "with a valid address without poll information" do
    before(:each) do  
      RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/white_house.json").read)
    end
    let (:vi) { VoterInfo.lookup("DC") }
    it "has a status of noStreetSegmentFound" do
      vi.status.should eq "noStreetSegmentFound"
    end
    it "returns an Address object for the normalized address" do
      vi.normalized_address.should be_a(Address)
    end
    it "has a normalized version of the address" do
      vi.normalized_address.city.should eq 'Washington'
    end
    it "has an empty array of polling places" do
      vi.polling_locations.should eq []
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
      vi.polling_locations.length.should be > 0
    end
    it "creates a polling location object for each location in the response" do
      PollingLocation.should_receive(:new).and_return(nil)
      vi.polling_locations.length
    end
    it "has early voting information" do
      vi.early_voting_places.length.should be > 0
    end
    it "creates an early voting place object for each location in the response" do
      PollingLocation.should_receive(:new).and_return(nil)
      vi.early_voting_places.length
    end
    it "has a status of success" do
      vi.status.should eq "success"
    end
  end
  context "with a no address returned message" do
    before (:each) do
      RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/no_address.json").read)
    end
    let (:vi) { VoterInfo.lookup("")}
    it "has a status of noAddressParameter" do
      vi.status.should eq 'noAddressParameter'
    end
    it "returns nil for the address" do
      vi.normalized_address.should be_nil
    end
    it "has an empty polling place array" do
      vi.polling_locations.length.should eq 0
    end
    it "has an empty early voting array" do
      vi.polling_locations.length.should eq 0
    end
  end
end
