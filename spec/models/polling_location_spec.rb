require 'spec_helper'

describe PollingLocation do
  describe 'field validation' do
    ADDRESS_VALUES = { line1: '230 Shazam Lane',
                       line2: '4th Floor',
                       line3: 'Suite 400',
                       city: 'San Diego',
                       state: 'CA',
                       zip: '92003' }
    ADDRESS_FIELDS = ADDRESS_VALUES.keys
    STRING_FIELDS = ADDRESS_FIELDS + [:name, :location_name, :county]
    before(:each) do
      @pl = PollingLocation.new(
        name: 'Precinct 235253 Polling Place',
        location_name: 'My house',
        line1: '230 Shazam Lane',
        line2: '4th Floor',
        line3: 'Suite 400',
        city: 'San Diego',
        state: 'CA',
        zip: '92003',
        county: '06073',
        latitude: 32.7153,
        longitude: 117.1564,
        properties: { 'foo' => 'bar',
                      'photo' => 'http://myfairelection.com/favicon.ico' },
        early_vote: true)
      @pl.feed = FactoryGirl.create(:feed)
      @pl.description = nil
    end
    it 'is valid with valid parameters' do
      @pl.should be_valid
    end
    context 'for fields which are part of the address' do
      it 'is invalid if none of the address fields are set' do
        ADDRESS_FIELDS.each do |param|
          @pl.send("#{param}=", nil)
        end
        @pl.should_not be_valid
      end
      ADDRESS_FIELDS.each do |param|
        before(:each) do
          @pl = PollingLocation.new
          @pl.send("#{param}=", ADDRESS_VALUES[param])
        end
        it "is valid if only #{param} is set" do
          @pl.should be_valid
        end
        it "can be saved if only #{param} is set" do
          @pl.save.should be_true
        end
      end
    end
    context 'for other fields' do
      [:name, :location_name, :county,
       :latitude, :longitude, :properties, :feed].each do |param|
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
    context 'for string fields' do
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
    it 'returns the properties in a hash' do
      @pl.properties.should be_a(Hash)
    end
    context 'for the early_vote property' do
      it 'defaults to false' do
        pl = PollingLocation.new
        pl.early_vote.should be_false
      end
      it 'does not default to nil!' do
        pl = PollingLocation.new
        pl.early_vote.should_not be_nil
      end
    end
    context 'for the state property' do
      it 'converts the state to all caps' do
        @pl.state = 'dc'
        @pl.state.should eq 'DC'
      end
      it 'is invalid if state is too short' do
        @pl.state = 'a'
        @pl.should_not be_valid
      end
      it 'chops the string if state is too long' do
        @pl.state = 'Ca.'
        @pl.state.should eq 'CA'
        @pl.should be_valid
      end
    end
    context 'for the zip property' do
      it 'is valid for 5-digit zips' do
        @pl.zip = '80014'
        @pl.should be_valid
      end
      it 'is valid for 9-digit zips' do
        @pl.zip = '80014-1233'
        @pl.should be_valid
      end
      it 'adds a hyphen to 9-digit zips without them' do
        @pl.zip = '123456789'
        @pl.should be_valid
        @pl.zip.should eq '12345-6789'
      end
      it 'removes a hyphen from 5-digit zips with them' do
        @pl.zip = '12345-'
        @pl.should be_valid
        @pl.zip.should eq '12345'
      end
      # Google seems to return garbage for zip code on occaision.
      it 'is valid for other things' do
        @pl.zip = '000IL'
        @pl.should be_valid
      end
      it 'removes leading spaces from 5-digit zips' do
        @pl.zip = '  55405'
        @pl.should be_valid
        @pl.zip.should eq '55405'
      end
    end
    context 'for the description property' do
      before(:each) do
        @pl = PollingLocation.new(state: 'CA')
        @pl.description = 'I voted at the card wash'
      end
      it 'is valid if state, and no other address field, is present' do
        @pl.should be_valid
      end
      ADDRESS_FIELDS.each do |param|
        it 'is invalid if address field #{param} is present' do
          unless param == :state
            @pl.send("#{param}=", ADDRESS_VALUES[param])
            @pl.should_not be_valid
          end
        end
      end
    end
  end
  it 'knows its reviews' do
    pl = FactoryGirl.create(:polling_location)
    review = FactoryGirl.create(:review, polling_location: pl,
                                         user: FactoryGirl.create(:user))
    pl.reviews.length.should be 1
    pl.reviews.first.id.should eq review.id
  end
  describe '::find_by_address' do
    class Foo
      def first
      end
    end
    before(:each) do
      PollingLocation.should_receive(:where).with(early_vote: false,
                                                  line1: '1040 W Addison St',
                                                  line2: nil,
                                                  line3: nil,
                                                  city: 'Chicago',
                                                  state: nil,
                                                  zip: nil
                                                  ).and_return(Foo.new)
    end
    it 'fills in missing attribs with nil or false' do
      PollingLocation.find_by_address(line1: '1040 W Addison St',
                                      city: 'Chicago')
    end
    it 'strips out fields not in the address' do
      PollingLocation.find_by_address(line1: '1040 W Addison St',
                                      city: 'Chicago', foo: :bar)
    end
  end
  describe '::find_or_create_from_google!' do
    let(:location_hash) do
      {
        'address' => {
          'locationName' => 'National Guard Armory',
          'line1' => '100 S 20th St',
          'line2' => 'string',
          'line3' => 'string',
          'city' => 'string',
          'state' => 'NV',
          'zip' => '80014'
        },
        'notes' => 'string',
        'pollingHours' => 'string',
        'name' => 'Precinct 23452 Polling Place',
        'voterServices' => 'string',
        'startDate' => 'string',
        'endDate' => 'string',
        'sources' => [
          {
            'name' => 'string',
            'official' => true
          }
        ]
      }
    end
    context 'with a new polling place' do
      let(:location) do
        PollingLocation.find_or_create_from_google!(location_hash)
      end
      it 'sets location_name' do
        location.location_name.should eq 'National Guard Armory'
      end
      it 'sets address' do
        location.line1.should eq '100 S 20th St'
      end
      it 'sets name' do
        location.name.should eq 'Precinct 23452 Polling Place'
      end
      it 'leaves unprovided fields nil' do
        %w(county latitude longitude).each do |field|
          location.send(field).should be_nil
        end
      end
      it 'leaves early_vote false' do
        location.early_vote?.should be_false
      end
      it 'puts everything else in properties' do
        %w(notes pollingHours voterServices startDate endDate sources)
        .each do |field|
          location.properties.keys.include?(field).should be_true
        end
      end
      context 'if early_vote is set' do
        let(:location) do
          PollingLocation.find_or_create_from_google!(location_hash, true)
        end
        it 'returns true for early_vote' do
          location.early_vote.should be_true
        end
      end
    end
    context 'with a duplicate polling place' do
      it 'returns the existing polling place' do
        loc1 = PollingLocation.find_or_create_from_google!(location_hash)
        PollingLocation.find_or_create_from_google!(location_hash)
        .should eq loc1
      end
      it 'returns a different polling place if early_vote is different' do
        loc1 = PollingLocation.find_or_create_from_google!(location_hash, true)
        PollingLocation.find_or_create_from_google!(location_hash, false)
        .should_not eq loc1
      end
    end
    it 'works with SF city hall twice' do
      location_hash = {
        'address' => {
          'locationName' => 'San Francisco City Hall',
          'line1' => '1 Dr. Carlton B Goodlett Place',
          'line2' => '',
          'city' => 'San Francisco',
          'state' => 'ca',
          'zip' => '94102'
        },
        'notes' => 'Enter City Hall at Grove Street, Room 48',
        'pollingHours' =>
          'M-F 8-5 and 10/27 10-4 and 10/28 10-4 and 11/3 10-4 and 11/4 10-4 ',
        'name' => 'Early Voting Center',
        'voterServices' => '',
        'startDate' => '9-Oct',
        'endDate' => '5-Nov',
        'sources' => [
          {
            'name' => 'Ballot Information Project',
            'official' => false
          }
        ]
      }
      loc1 = PollingLocation.find_or_create_from_google!(location_hash, true)
      loc2 = PollingLocation.find_or_create_from_google!(location_hash, true)
      loc1.should eq loc2
    end
    context 'with minnesota result, stripping whitespace' do
      let(:location_hash) do
        {
          'address' => {
            'line1' => '252 UPTON AVE S',
            'city' => 'MINNEAPOLIS ',
            'state' => 'MN',
            'zip' => '  55405'
          },
          'notes' => '',
          'pollingHours' => '',
          'sources' => [
            {
              'name' => 'Voting Information Project',
              'official' => true
            }
          ]
        }
      end
      let(:pl) do
        PollingLocation.find_or_create_from_google!(location_hash, true)
      end
      it 'strips whitespace from the city' do
        pl.city.should eq 'MINNEAPOLIS'
      end
    end
    context 'with an identical address, but other has changed' do
      let(:updated_location_hash) do
        {
          'address' => {
            'locationName' => 'National Guard Armory',
            'line1' => '100 S 20th St',
            'line2' => 'string',
            'line3' => 'string',
            'city' => 'string',
            'state' => 'NV',
            'zip' => '80014'
          },
          'notes' => 'New notes!',
          'pollingHours' => 'New polling hours!',
          'name' => 'New name!',
          'somethingElse' => 'andMore!'
         }
      end
      before(:each) do
        @loc1 = PollingLocation.find_or_create_from_google!(location_hash)
        @loc2 = PollingLocation
                  .find_or_create_from_google!(updated_location_hash)
      end
      it 'returns the existing object' do
        @loc1.should eq @loc2
      end
      it 'updates the object with the new information' do
        @loc2.name.should eq 'New name!'
        @loc2.properties['notes'].should eq 'New notes!'
        @loc2.properties['pollingHours'].should eq 'New polling hours!'
      end
      it 'merges the properties' do
        %w(notes pollingHours voterServices startDate
           endDate sources somethingElse).each do |attrib|
          @loc2.properties[attrib].should_not be_nil
        end
      end
    end
    it 'creates two polling locations with inputs with different addresses' do
      hash1 =
        { 'address' =>
          {
            'locationName' => 'National Guard Armory',
            'line1' => '100 S 20th St',
            'city' => 'Reno',
            'state' => 'NV',
            'zip' => '80014'
          }
        }
      hash2 =
        { 'address' =>
          {
            'locationName' => 'The White House',
            'line1' => '1600 Pennsylvania Ave NW',
            'city' => 'Washington',
            'state' => 'DC',
            'zip' => '20500'
          }
        }
      PollingLocation.find_or_create_from_google!(hash1)
      PollingLocation.find_or_create_from_google!(hash2)
      PollingLocation.count.should eq 2
    end
  end

  describe '::update_or_create_from_xml!' do
    let(:early_location_xml) do
      <<POLLING_LOCATION
<early_vote_site id="30203">
  <name>Adams Early Vote Center</name>
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state> </state>
    <zip />
    <point>
      <lat>39.03991</lat>
      <long>-76.99542</long>
    </point>
  </address>
  <directions>Follow signs to early vote</directions>
  <voter_services>Early voting is available.</voter_services>
  <start_date>2012-10-01</start_date>
  <end_date>2012-11-04</end_date>
  <days_times_open>Mon-Fri: 9am - 6pm. Sat.
                   and Sun.: 10am - 7pm.</days_times_open>
</early_vote_site>
POLLING_LOCATION
    end
    let(:day_of_xml) do
      <<POLLING_LOCATION
<polling_location id="30203">
  <name>Adams Early Vote Center</name>
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state> </state>
    <zip />
    <point>
      <lat>39.03991</lat>
      <long>-76.99542</long>
    </point>
  </address>
  <directions>Follow signs to early vote</directions>
  <voter_services>Early voting is available.</voter_services>
  <start_date>2012-10-01</start_date>
  <end_date>2012-11-04</end_date>
  <days_times_open>Mon-Fri: 9am - 6pm. Sat.
                   and Sun.: 10am - 7pm.</days_times_open>
</polling_location>
POLLING_LOCATION
    end
    context 'with a new polling place which is an early vote site' do
      let(:location) do
        PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(early_location_xml).read)
      end
      it 'sets early_vote' do
        location.early_vote?.should be_true
      end
      it 'sets location_name' do
        location.location_name.should eq 'Adams County Government Center'
      end
      it 'sets address' do
        location.line1.should eq '321 Main St.'
      end
      it 'sets name' do
        location.name.should eq 'Adams Early Vote Center'
      end
      it 'sets latitude' do
        location.latitude.should eq '39.03991'.to_f
      end
      it 'sets longitude' do
        location.longitude.should eq '-76.99542'.to_f
      end
      it 'leaves county nil' do
        location.county.should be_nil
      end
      it 'puts everything else in properties' do
        %w(directions voter_services start_date
           end_date days_times_open).each do |field|
          location.properties.keys.include?(field).should be_true
        end
      end
      it 'sets value to nil for empty tag' do
        location.state.should be_nil
      end
      it 'sets value to nil for self closing tag' do
        location.zip.should be_nil
      end
    end
    context 'with a new polling place which is a day of site' do
      let(:location) do
        PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(day_of_xml).read)
      end
      it 'sets early_vote' do
        location.early_vote?.should be_false
      end
    end
    context 'with a duplicate polling place' do
      it 'returns the existing polling place' do
        loc1 = PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(early_location_xml).read)
        PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(early_location_xml).read).should eq loc1
      end
    end
    context 'with same address but different early_vote' do
      it 'returns a different polling place' do
        loc1 = PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(early_location_xml).read)
        PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(day_of_xml).read).should_not eq loc1
      end
    end
    context 'with an identical address, but other has changed' do
      let(:updated_location_xml) do
        <<POLLING_LOCATION
<early_vote_site id="30203">
  <name>New name!</name>
  <address>
    <location_name>Adams County Government Center</location_name>
    <line1>321 Main St.</line1>
    <line2>Suite 200</line2>
    <city>Adams</city>
    <state> </state>
    <zip />
    <point>
      <lat>39.03991</lat>
      <long>-76.99542</long>
    </point>
  </address>
  <directions>New directions!</directions>
  <voter_services>Early voting is available.</voter_services>
  <start_date>2012-10-01</start_date>
  <end_date>2012-11-04</end_date>
  <days_times_open>Mon-Fri: 9am - 6pm. Sat.
                   and Sun.: 10am - 7pm.</days_times_open>
</early_vote_site>
POLLING_LOCATION
      end
      before(:each) do
        @loc1 = PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(early_location_xml).read)
        @loc2 = PollingLocation.update_or_create_from_xml!(
          Nokogiri::XML::Reader(updated_location_xml).read)
      end
      it 'returns the existing object' do
        @loc1.should eq @loc2
      end
      it 'updates the object with the new information' do
        @loc2.name.should eq 'New name!'
        @loc2.properties['directions'].should eq 'New directions!'
      end
    end
    it 'creates two polling locations with inputs with different addresses' do
      xml1 = <<POLLING_LOCATION
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
      xml2 = <<POLLING_LOCATION
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
      PollingLocation.update_or_create_from_xml!(
        Nokogiri::XML::Reader(xml1).read)
      PollingLocation.update_or_create_from_xml!(
        Nokogiri::XML::Reader(xml2).read)
      PollingLocation.count.should eq 2
    end
    it 'works correctly when loading from a file' do
      feed_file = open('spec/fixtures/test_feeds/sample_feed_for_v3.0.xml')
      feed_xml = Nokogiri::XML::Reader(feed_file)

      while feed_xml.read
        next unless (feed_xml.node_type ==
                     Nokogiri::XML::Reader::TYPE_ELEMENT) and 
                    (%w(polling_location early_vote_site)
                      .include?(feed_xml.name))
        pl = PollingLocation.update_or_create_from_xml!(feed_xml)
        pl.save!
      end

      PollingLocation.count.should eq 6
    end
  end
  it 'leaves lat/long in the object on updates' do
    xml = <<POLLING_LOCATION
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
    pl = PollingLocation.update_or_create_from_xml!(
      Nokogiri::XML::Reader(xml).read)
    pl.latitude = 100
    pl.longitude = 100
    pl.county = 'Columbiana'
    pl.save!
    pl = PollingLocation.update_or_create_from_xml!(
      Nokogiri::XML::Reader(xml).read)
    pl.latitude.should eq(100)
    pl.longitude.should eq(100)
    pl.county.should eq('Columbiana')
  end
end
