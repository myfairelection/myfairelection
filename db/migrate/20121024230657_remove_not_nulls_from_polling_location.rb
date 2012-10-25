class RemoveNotNullsFromPollingLocation < ActiveRecord::Migration
  def up
    change_column :polling_locations, :line1, :string, :null => true
    change_column :polling_locations, :city, :string, :null => true
    change_column :polling_locations, :state, :string, :null => true
  end

  def down
    change_column :polling_locations, :line1, :string, :null => false
    change_column :polling_locations, :city, :string, :null => false
    change_column :polling_locations, :state, :string, :null => false
  end
end
