class Review < ActiveRecord::Base
  attr_accessible :able_to_vote, :comments, :polling_location, :rating, :user, :voted_day, :voted_time, :wait_time, :ip_address
  validates_presence_of :polling_location, :user
  validates :user_id, :uniqueness => { :scope => :polling_location_id }
  validates :voted_time, :format => { :with => /\A[012][0-9]:[0-5][0-9]\z$/ }, :allow_nil => true
  validates :voted_day, :format => { :with => /\A[01][0-9]-[0-3][0-9]?\z/}, :allow_nil => true
  belongs_to :polling_location
  belongs_to :user
end
