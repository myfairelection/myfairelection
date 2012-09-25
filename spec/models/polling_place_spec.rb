require 'spec_helper'

describe PollingPlace do
  describe "::lookup" do
    let (:address) { "1600 Pennsylvania Avenue Northwest, Washington, DC 20500" }
    it "returns a polling place object" do
      expect(PollingPlace.lookup(address)).to be_kind_of(PollingPlace)
    end
  end
  context "with a valid address" do
    context "with polling place data" do
      let (:address) { "1263 Pacific Ave. Kansas City KS" }
      let (:pp) { PollingPlace.lookup(address) }
      it "has the name of the location" do
        expect(pp.name).to eq("National Guard Armory")
      end
      it "has the street address" do 
        expect(pp.street).to eq("100 S 20th St")
      end
      it "has the state" do 
        expect(pp.state).to be_kind_of(String) 
      end
      it "has the city" do 
        expect(pp.city).to be_kind_of(String) 
      end
      it "has the zip code" do 
        expect(pp.zip).to be_kind_of(String) 
      end
      it "has the opening hours" do 
        expect(pp.hours).to be_kind_of(String) 
      end
    end
    context "without polling place data" do
    end
  end
  context "with an invalid address" do
  end
end