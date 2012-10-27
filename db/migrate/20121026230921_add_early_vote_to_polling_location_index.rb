class AddEarlyVoteToPollingLocationIndex < ActiveRecord::Migration
  def up
    remove_index :polling_locations, :name => "index_polling_locations_on_address"
    add_index :polling_locations, [:early_vote, :state, :city, :zip, :line1], :name => "index_polling_locations_on_address"
  end

  def down
    remove_index :polling_locations, :name => "index_polling_locations_on_address"
    add_index :polling_locations, [:state, :city, :zip, :line1], :name => "index_polling_locations_on_address"
  end
end
