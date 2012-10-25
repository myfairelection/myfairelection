require 'spec_helper'

describe PollingLocation do
  ADDRESS_FIELDS = [:line1, :line2, :line3, :city, :state, :zip]
  STRING_FIELDS = [:line1, :line2, :line3, :city, :state, :zip, :name, :location_name, :county]
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
    @pl.feed = FactoryGirl.create(:feed)
  end
  it "is valid with valid parameters" do
    @pl.should be_valid
  end
  context "for fields which are part of the address" do
    it "is invalid if none of the address fields are set" do
      ADDRESS_FIELDS.each do |param|
        @pl.send("#{param}=", nil)
      end
      @pl.should_not be_valid
    end
    ADDRESS_FIELDS.each do |param|
      it "is valid if only #{param} is set" do
        pl = PollingLocation.new
        pl.send("#{param}=", "CA")
        pl.should be_valid
      end
      it "can be saved if only #{param} is set" do
        pl = PollingLocation.new
        pl.send("#{param}=", "CA")
        pl.save.should be_true
      end
    end
  end
  context "for other fields" do
    [:name, :location_name, :county, :latitude, :longitude, :properties, :feed].each do |param|
      it "is valid without #{param}" do
        @pl.send("#{param}=", nil)
        @pl.should be_valid
      end
      it "can be saved without #{param}" do
        @pl.send("#{param}=", nil)
        @pl.save.should be_true
      end
    end
  end
  context "for string fields" do
    STRING_FIELDS.each do |param|
      it "converts blank string to nil for #{param}" do
        @pl.send("#{param}=", ' ')
        @pl.save
        @pl.send("#{param}").should be_nil
      end
      it "converts empty string to nil for #{param}" do
        @pl.send("#{param}=", '')
        @pl.save
        @pl.send("#{param}").should be_nil
      end
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

  describe "::find_by_address" do
    class Foo
      def first
      end
    end
    before(:each) do       
      PollingLocation.should_receive(:where).with({line1: "1040 W Addison St",
                                                   line2: nil,
                                                   line3: nil,
                                                   city: "Chicago",
                                                   state: nil,
                                                   zip: nil
                                                  }).and_return(Foo.new)
    end
    it "fills in missing attribs with nil" do
      PollingLocation.find_by_address({line1: "1040 W Addison St", city: "Chicago"})
    end
    it "strips out fields not in the address" do
      PollingLocation.find_by_address({line1: "1040 W Addison St", city: "Chicago", foo: :bar})
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
          "somethingElse" => "andMore!"
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
      it "merges the properties" do
        ["notes", "pollingHours", "voterServices", "startDate", "endDate", "sources", "somethingElse"].each do |attrib|
          @loc2.properties[attrib].should_not be_nil
        end
      end
    end
    it "creates two polling locations with inputs with different addresses" do
      hash1 = 
        { "address" => {
            "locationName" => "National Guard Armory",
            "line1" => "100 S 20th St",
            "city" => "Reno",
            "state" => "NV",
            "zip" => "80014",
          }
        }
      hash2 = 
        { "address" => {
            "locationName" => "The White House",
            "line1" => "1600 Pennsylvania Ave NW",
            "city" => "Washington",
            "state" => "DC",
            "zip" => "20500",
          }
        }
      PollingLocation.find_or_create_from_google!(hash1)
      PollingLocation.find_or_create_from_google!(hash2)
      PollingLocation.count.should eq 2
    end
  end

  describe "::update_or_create_from_xml!" do
    let (:location_xml) {
      Nokogiri::XML <<POLLING_LOCATION
<early_vote_site id="30203">
  <name>Adams Early Vote Center</name>
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state>OH</state>
    <zip>42224</zip>
    <point>
      <lat>39.03991</lat>
      <long>-76.99542</long>
    </point>
  </address>
  <directions>Follow signs to early vote</directions>
  <voter_services>Early voting is available.</voter_services>
  <start_date>2012-10-01</start_date>
  <end_date>2012-11-04</end_date>
  <days_times_open>Mon-Fri: 9am - 6pm. Sat. and Sun.: 10am - 7pm.</days_times_open>
</early_vote_site>
POLLING_LOCATION
    }
    context "with a new polling place" do
      let (:location) { PollingLocation.update_or_create_from_xml!(location_xml) }
      it "sets location_name" do
        location.location_name.should eq "Adams County Government Center"
      end
      it "sets address" do
        location.line1.should eq "321 Main St."
      end
      it "sets name" do
        location.name.should eq "Adams Early Vote Center"
      end
      it "sets latitude" do
        location.latitude.should eq "39.03991".to_f
      end
      it "sets longitude" do
        location.longitude.should eq "-76.99542".to_f
      end
      it "leaves county nil" do
        location.county.should be_nil
      end
      it "puts everything else in properties" do
        ["directions", "voter_services", "start_date", "end_date", "days_times_open"].each do |field|
          location.properties.keys.include?(field).should be_true
        end
      end
    end
    context "with a duplicate polling place" do
      it "returns the existing polling place" do
        loc1 = PollingLocation.update_or_create_from_xml!(location_xml)
        PollingLocation.update_or_create_from_xml!(location_xml).should eq loc1
      end
    end
    context "with an identical address, but other has changed" do
      let(:updated_location_xml) {
      Nokogiri::XML <<POLLING_LOCATION
<early_vote_site id="30203">
  <name>New name!</name>
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state>OH</state>
    <zip>42224</zip>
    <point>
      <lat>39.03991</lat>
      <long>-76.99542</long>
    </point>
  </address>
  <directions>New directions!</directions>
  <voter_services>Early voting is available.</voter_services>
  <start_date>2012-10-01</start_date>
  <end_date>2012-11-04</end_date>
  <days_times_open>Mon-Fri: 9am - 6pm. Sat. and Sun.: 10am - 7pm.</days_times_open>
</early_vote_site>
POLLING_LOCATION
      }
      before(:each) do
        @loc1 = PollingLocation.update_or_create_from_xml!(location_xml)
        @loc2 = PollingLocation.update_or_create_from_xml!(updated_location_xml)
      end
      it "returns the existing object" do
        @loc1.should eq @loc2
      end
      it "updates the object with the new information" do
        @loc2.name.should eq "New name!"
        @loc2.properties["directions"].should eq "New directions!"
      end
    end
    it "creates two polling locations with inputs with different addresses" do
      xml1 = 
      Nokogiri::XML <<POLLING_LOCATION
<early_vote_site id="30203">
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state>OH</state>
    <zip>42224</zip>
  </address>
</early_vote_site>
POLLING_LOCATION
      xml2 = 
      Nokogiri::XML <<POLLING_LOCATION
<early_vote_site id="30203">
  <address>
    <location_name>The White House</location_name>
    <line1>1600 Pennsylvania Ave NW</line1>
    <city>Washington</city>
    <state>DC</state>
    <zip>20500</zip>
  </address>
</early_vote_site>
POLLING_LOCATION
      PollingLocation.update_or_create_from_xml!(xml1)
      PollingLocation.update_or_create_from_xml!(xml2)
      PollingLocation.count.should eq 2
    end
    it "works correctly when loading from a file" do
      feed_file = open("spec/fixtures/test_feeds/sample_feed_for_v4.0.xml")
      feed_xml = Nokogiri::XML(feed_file)

      ["//polling_location", "//early_vote_site"].each do |xpath|
        pl_nodes = feed_xml.xpath(xpath)

        pl_nodes.each do |pl_node|
          pl = PollingLocation.update_or_create_from_xml!(pl_node)
          pl.save!
        end   
      end

      PollingLocation.count.should eq 6
    end
  end
end
