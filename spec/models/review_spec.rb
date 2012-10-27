require 'spec_helper'

describe Review do
  let (:polling_location) { FactoryGirl.create(:polling_location)}
  let (:user) { FactoryGirl.create(:user) }
  before(:each) do
    @review = Review.new(
      able_to_vote: true,
      comments: "This place was smelly.",
      polling_location_id: polling_location.id,
      rating: 4,
      user_id: user.id,
      voted_at: Time.now,
      wait_time: 15
    )
  end
  it "is valid with valid parameters" do
    @review.should be_valid
  end
end
