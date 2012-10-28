class Review < ActiveRecord::Base
  attr_accessible :able_to_vote, :comments, :polling_location, :rating, :user, :voted_at, :wait_time, :ip_address
  validates_presence_of :polling_location, :user
  validates :user_id, :uniqueness => { :scope => :polling_location_id }
  belongs_to :polling_location
  belongs_to :user
end
