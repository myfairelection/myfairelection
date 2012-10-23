class AddFeedToPollingLocation < ActiveRecord::Migration
  def change
    add_column :polling_locations, :feed_id, :integer
  end
end
