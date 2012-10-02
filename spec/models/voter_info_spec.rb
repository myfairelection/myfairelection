require 'spec_helper'

describe VoterInfo do
  describe "::lookup" do
    let (:address) { "1600 Pennsylvania Avenue Northwest, Washington, DC 20500" }
    it "returns a polling place object" do
      expect(VoterInfo.lookup(address)).to be_kind_of(VoterInfo)
    end
  end
  context "with a valid address without poll information" do
    let (:address) { "1600 Pennsylvania Avenue Northwest, Washington, DC 20500" }
    let (:vi) { VoterInfo.lookup(address) }
    it "has a normalized version of the address" do
      vi.normalized_address.city.should eq 'Washington'
    end
    it "has an empty array of polling places" do
      vi.polling_places.should eq []
    end
  end
  context "with a valid address with poll information" do
    let (:address) { "1263 Pacific Ave. Kansas City KS" }
    let (:vi) { VoterInfo.lookup(address) }
    it "has a normalized version of the address" do
      vi.normalized_address.city.should eq 'Kansas City'
    end
    it "has a polling place" do
      vi.polling_places.length.should be > 0
    end
    it "has early voting information" do
      pending "test address with early voting information"
      vi.early_voting_places.length.should be > 0
    end
  end
end