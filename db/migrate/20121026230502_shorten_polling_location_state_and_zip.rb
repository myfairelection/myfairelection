class ShortenPollingLocationStateAndZip < ActiveRecord::Migration
  def up
    change_column :polling_locations, :state, :string, :null => true, :limit => 2
    change_column :polling_locations, :zip, :string, :null => true, :limit => 10
  end

  def down
    change_column :polling_locations, :state, :string, :null => true
    change_column :polling_locations, :zip, :string, :null => true
  end
end
