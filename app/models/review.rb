class Review < ActiveRecord::Base
  validates_presence_of :polling_location, :user
  validates :user_id, uniqueness: { scope: :polling_location_id }
  validates :voted_time, format: { with: /\A[012][0-9]:[0-5][0-9]\z/ },
                         allow_nil: true
  validates :voted_day, format: { with: /\A[01][0-9]-[0-3][0-9]?\z/ },
                        allow_nil: true
  belongs_to :polling_location
  belongs_to :user
end
