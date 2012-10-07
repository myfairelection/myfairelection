require 'spec_helper'

describe Feed do
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
  describe '#load' do
    context "with a network url" do
      before(:each) do
        @feed = Feed.new({:url => "https://raw.github.com/votinginfoproject/vip-specification/master/sample_feed_for_v4.0.xml"})
      end
      it "retrieves the specified url" 
    end
    context "with a file url" do
      before(:each) do
        @feed = Feed.new({:url => "spec/test_feeds/sample_feed_for_v4.0.xml"})
      end
      it "populates the version field" do
        @feed.load
        @feed.version.should eq("4.0")
      end
      it "populates the vip_id field" do
        @feed.load
        @feed.vip_id.should eq("39")
      end
      it "marks the feed as loaded" do
        @feed.load
        @feed.should be_loaded
      end
      it "creates 3 PollingLocation objects" do
        expect {
          @feed.load
        }.to change{PollingLocation.count}.by(3)
      end
    end
  end
end
