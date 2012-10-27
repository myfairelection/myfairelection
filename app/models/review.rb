class Review < ActiveRecord::Base
  attr_accessible :able_to_vote, :comments, :polling_location_id, :rating, :user_id, :voted_at, :wait_time
end
