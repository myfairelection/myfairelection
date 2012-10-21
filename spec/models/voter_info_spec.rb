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
    context "with polling places not in the database" do
      before(:each) do  
        RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/ks_response.json").read)
      end
      let (:vi) { VoterInfo.lookup("KS") }
      it "has a normalized version of the address" do
        vi.normalized_address.city.should eq 'Kansas City'
      end
      it "returns all the polling places" do
        vi.polling_locations.length.should eq 1
      end
      context "the polling place list" do
        it "contains activerecord objects" do
          vi.polling_locations.each do |pl|
            pl.should be_persisted
          end
        end
        it "created these new objects" do
          expect {
            VoterInfo.lookup("KS").polling_locations
          }.to change{PollingLocation.count}.by(1)
        end
      end
      it "returns all the early vote sites" do
        vi.early_voting_places.length.should eq 1
      end
      context "the early voting site list" do
        it "contains activerecord objects" do
          vi.early_voting_places.each do |pl|
            pl.should be_persisted
          end
        end
        it "created these new objects" do
          expect {
            VoterInfo.lookup("KS").early_voting_places
          }.to change{PollingLocation.count}.by(1)
        end
      end
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
