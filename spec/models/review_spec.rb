require 'spec_helper'

describe Review do
  let (:polling_location) { FactoryGirl.create(:polling_location)}
  let (:user) { FactoryGirl.create(:user) }
  before(:each) do
    @review = Review.new(
      able_to_vote: true,
      comments: "This place was smelly.",
      polling_location: polling_location,
      rating: 4,
      user: user,
      voted_at: Time.now,
      wait_time: 15,
      ip_address: "128.32.47.18"
    )
  end
  it "is valid with valid parameters" do
    @review.should be_valid
  end
  it "is invalid without a polling location" do
    @review.polling_location = nil
    @review.should_not be_valid
  end
  it "is invalid without a user" do
    @review.user = nil
    @review.should_not be_valid
  end
  it "knows its polling location" do
    expect(@review.polling_location).to eq polling_location
  end
  it "knows its user" do
    expect(@review.user).to eq user
  end
end
