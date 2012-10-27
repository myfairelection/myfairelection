class AddEarlyVoteToPollingLocation < ActiveRecord::Migration
  def change
    add_column :polling_locations, :early_vote, :boolean, :default => false
  end
end
