require 'spec_helper'

describe Review, :type => :model do
  let(:polling_location) { FactoryGirl.create(:polling_location) }
  let(:user) { FactoryGirl.create(:user) }
  after(:all) do
    polling_location.destroy
    user.destroy
  end
  before(:each) do
    @review = Review.new(
      able_to_vote: true,
      comments: 'This place was smelly.',
      polling_location: polling_location,
      rating: 4,
      user: user,
      voted_day: '11-06',
      voted_time: '22:30',
      wait_time: 15,
      ip_address: '128.32.47.18'
    )
  end
  it 'is valid with valid parameters' do
    expect(@review).to be_valid
  end
  it 'is invalid without a polling location' do
    @review.polling_location = nil
    expect(@review).not_to be_valid
  end
  it 'is invalid without a user' do
    @review.user = nil
    expect(@review).not_to be_valid
  end
  it 'knows its polling location' do
    expect(@review.polling_location).to eq polling_location
  end
  it 'knows its user' do
    expect(@review.user).to eq user
  end
  it 'only allows one review per location/user combo' do
    Review.new(user: user, polling_location: polling_location).save
    expect(Review.new(user: user,
               polling_location: polling_location)).not_to be_valid
  end
  describe 'voted_day' do
    it 'is invalid if not in right format' do
      @review.voted_day = '12323554'
      expect(@review).not_to be_valid
    end
    it 'is invalid if not a legal date' do
      @review.voted_day = '23-83'
      expect(@review).not_to be_valid
    end
    it 'is valid if it is election day' do
      @review.voted_day = '11-06'
      expect(@review).to be_valid
    end
  end
  describe 'voted_time' do
    it 'is invalid if not in right format' do
      @review.voted_time = '232325'
      expect(@review).not_to be_valid
    end
    it 'is invalid if not a legal time' do
      @review.voted_time = '35:73'
      expect(@review).not_to be_valid
    end
  end
end
