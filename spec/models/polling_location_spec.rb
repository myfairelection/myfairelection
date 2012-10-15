require 'spec_helper'

describe PollingLocation do
  describe "#initialize" do
    it "works with no args" do
      a = PollingLocation.new
      a.should be_a(PollingLocation)
    end
    context "with a full location object" do
      let (:location_hash) {
        {
         "address" => {
          "locationName" => "National Guard Armory",
          "line1" => "100 S 20th St",
          "city" => "Kansas City",
          "state" => "KS",
          "zip" => "66102 "
         },
         "pollingHours" => "8:00am to 8:00pm",
         "sources" => [
          {
           "name" => "Voting Information Project",
           "official" => "true"
          }
         ]
        }
      }
      let (:location) { PollingLocation.new(location_hash) }
      it "sets location_name" do
        location.location_name.should eq "National Guard Armory"
      end
      it "sets address" do
        location.address.should be_a(Address)
      end
      it "sets polling_hours" do
        location.polling_hours.should eq "8:00am to 8:00pm"
      end
      it "puts everything else in properties" do
        location.properties.keys.should eq ["sources"]
      end
    end
  end
end
