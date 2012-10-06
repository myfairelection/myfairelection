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
  it "verifies uniqueness of url" 
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
    it "retrieves the specified url"
    it "populates the version field"
    it "populates the vip_id field"
    it "updates the last loaded date"
    it "creates 3 PollingLocation objects"
  end
end
