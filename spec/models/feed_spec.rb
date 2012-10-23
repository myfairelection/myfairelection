require 'spec_helper'

describe Feed do
  describe "::load_from_file" do
    let (:filename) { "spec/fixtures/test_feeds/sample_feed_for_v4.0.xml" }
    it "creates a new feed object with the file" do
      expect {
        Feed.load_from_file filename
      }.to change{Feed.count}.by(1)
    end
    it "calls load on the just created feed object" do
      Feed.any_instance.should_receive(:load_objects)
      Feed.load_from_file filename
    end
  end
  before(:each) do
    @feed = Feed.new({:url => "https://example.com/test.txt", :vip_id => "39", :version => "4.0"},
                     :without_protection => true)
  end
  it "is valid with valid parameters" do
    @feed.should be_valid
  end
  it "is not valid without a url" do
    @feed.url = nil
    @feed.should_not be_valid
  end
  it "verifies uniqueness of url" do
    @feed.save
    newfeed = Feed.new({:url => "https://example.com/test.txt"})
    newfeed.should_not be_valid
  end
  it "is valid without a vip_id" do
    @feed.vip_id = nil
    @feed.should be_valid
  end
  it "is valid without a version" do
    @feed.version = nil
    @feed.should be_valid
  end
  it "has not been loaded at creation" do
    @feed.loaded?.should be_false
  end
  describe '#url_basename' do
    it "returns the last part of the path" do
      @feed.url_basename.should == 'test.txt'
    end
  end
  describe '#load_objects' do
    context "with a file url" do
      before(:each) do
        @feed = Feed.create!({:url => "spec/fixtures/test_feeds/sample_feed_for_v4.0.xml"})
        PollingLocation.should_receive(:update_or_create_from_xml!).with(any_args()).exactly(6).times.and_return(FactoryGirl.create(:polling_location))
      end
      it "populates the version field" do
        @feed.load_objects
        @feed.version.should eq("4.0")
      end
      it "populates the vip_id field" do
        @feed.load_objects
        @feed.vip_id.should eq("39")
      end
      it "marks the feed as loaded" do
        @feed.load_objects
        @feed.should be_loaded
      end
    end
  end
end
