require 'spec_helper'

describe Feed, type: :model do
  describe '::load_from_file' do
    let(:filename) { 'spec/fixtures/test_feeds/sample_feed_for_v3.0.xml' }
    it 'creates a new feed object with the file' do
      expect do
        Feed.load_from_file filename
      end.to change { Feed.count }.by(1)
    end
    it 'calls load on the just created feed object' do
      expect_any_instance_of(Feed).to receive(:load_objects)
      Feed.load_from_file filename
    end
  end
  before(:each) do
    @feed = Feed.new({ url: 'https://example.com/test.txt', vip_id: '39',
                       version: '4.0' },
                     without_protection: true)
  end
  it 'is valid with valid parameters' do
    expect(@feed).to be_valid
  end
  it 'is not valid without a url' do
    @feed.url = nil
    expect(@feed).not_to be_valid
  end
  it 'verifies uniqueness of url' do
    @feed.save
    newfeed = Feed.new(url: 'https://example.com/test.txt')
    expect(newfeed).not_to be_valid
  end
  it 'is valid without a vip_id' do
    @feed.vip_id = nil
    expect(@feed).to be_valid
  end
  it 'is valid without a version' do
    @feed.version = nil
    expect(@feed).to be_valid
  end
  it 'has not been loaded at creation' do
    expect(@feed.loaded?).to be_falsey
  end
  describe '#url_basename' do
    it 'returns the last part of the path' do
      expect(@feed.url_basename).to eq('test.txt')
    end
  end
  describe '#load_objects' do
    context 'with a file url' do
      before(:each) do
        @feed = Feed.create!(
          url: 'spec/fixtures/test_feeds/sample_feed_for_v3.0.xml')
        expect(PollingLocation).to receive(:update_or_create_from_xml!)
          .with(any_args).exactly(6).times
          .and_return(FactoryGirl.create(:polling_location))
      end
      it 'populates the version field' do
        @feed.load_objects
        expect(@feed.version).to eq('3.0')
      end
      it 'populates the vip_id field' do
        @feed.load_objects
        expect(@feed.vip_id).to eq('39')
      end
      it 'marks the feed as loaded' do
        @feed.load_objects
        expect(@feed).to be_loaded
      end
    end
  end
end
