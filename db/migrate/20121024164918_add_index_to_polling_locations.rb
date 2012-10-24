class AddIndexToPollingLocations < ActiveRecord::Migration
  def change
    add_index :polling_locations, [:state, :city, :zip, :line1], :name => "index_polling_locations_on_address"
  end
end
