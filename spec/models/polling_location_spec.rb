require 'spec_helper'

describe PollingLocation do
  before(:each) do
    @pl = PollingLocation.new(
      :name => "Precinct 235253 Polling Place",
      :location_name => "My house",
      :line1 => "230 Shazam Lane",
      :line2 => "4th Floor",
      :line3 => "Suite 400",
      :city => "San Diego",
      :state => "CA",
      :zip => "92003",
      :county => "06073",
      :latitude => 32.7153, 
      :longitude => 117.1564,
      :properties => {"foo" => "bar", "photo" => "http://myfairelection.com/favicon.ico"})
  end
  it "is valid with valid parameters" do
    @pl.should be_valid
  end
  [:line1, :city, :state].each do |param|
      it "is not valid without #{param}" do
        @pl.send("#{param}=", nil)
        @pl.should_not be_valid
      end
  end
  [:name, :location_name, :line2, :line3, :county, :latitude, :longitude, :properties, :zip].each do |param|
    it "is valid without #{param}" do
      @pl.send("#{param}=", nil)
      @pl.should be_valid
    end
  end
  it "returns the properties in a hash" do
    @pl.properties.should be_a(Hash)
  end
  context "for the state property" do
    it "converts the state to all caps" do
      @pl.state = "dc"
      @pl.state.should eq "DC"
    end
    it "is invalid if state is too short" do
      @pl.state= "a"
      @pl.should_not be_valid
    end
    it "is invalid if state is too long" do
      @pl.state = "Louisiana"
      @pl.should_not be_valid
    end
  end

  describe "::find_or_create_from_google!" do
    let (:location_hash) {
      {
        "address" => {
          "locationName" => "National Guard Armory",
          "line1" => "100 S 20th St",
          "line2" => "string",
          "line3" => "string",
          "city" => "string",
          "state" => "NV",
          "zip" => "string",
        },
        "notes" => "string",
        "pollingHours" => "string",
        "name" => "Precinct 23452 Polling Place",
        "voterServices" => "string",
        "startDate" => "string",
        "endDate" => "string",
        "sources" => [
          {
            "name" => "string",
            "official" => true
          }
        ]
      }
    }
    context "with a new polling place" do
      let (:location) { PollingLocation.find_or_create_from_google!(location_hash) }
      it "sets location_name" do
        location.location_name.should eq "National Guard Armory"
      end
      it "sets address" do
        location.line1.should eq "100 S 20th St"
      end
      it "sets name" do
        location.name.should eq "Precinct 23452 Polling Place"
      end
      it "leaves unprovided fields nil" do
        ["county", "latitude", "longitude"].each do |field|
          location.send(field).should be_nil
        end
      end
      it "puts everything else in properties" do
        ["notes", "pollingHours", "voterServices", "startDate", "endDate", "sources"].each do |field|
          location.properties.keys.include?(field).should be_true
        end
      end
    end
    context "with a duplicate polling place" do
      it "returns the existing polling place" do
        loc1 = PollingLocation.find_or_create_from_google!(location_hash)
        PollingLocation.find_or_create_from_google!(location_hash).should eq loc1
      end
    end
    context "with an identical address, but other has changed" do
      let(:updated_location_hash) {
        {
          "address" => {
            "locationName" => "National Guard Armory",
            "line1" => "100 S 20th St",
            "line2" => "string",
            "line3" => "string",
            "city" => "string",
            "state" => "NV",
            "zip" => "string",
          },
          "notes" => "New notes!",
          "pollingHours" => "New polling hours!",
          "name" => "New name!",
         }
      }
      before(:each) do
        @loc1 = PollingLocation.find_or_create_from_google!(location_hash)
        @loc2 = PollingLocation.find_or_create_from_google!(updated_location_hash)
      end
      it "returns the existing object" do
        @loc1.should eq @loc2
      end
      it "updates the object with the new information" do
        @loc2.name.should eq "New name!"
        @loc2.properties["notes"].should eq "New notes!"
        @loc2.properties["pollingHours"].should eq "New polling hours!"
      end
    end
  end
end
