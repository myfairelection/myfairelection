class AddDescriptionToPollingLocation < ActiveRecord::Migration
  def change
    add_column :polling_locations, :description, :text
    add_column :polling_locations, :created_at, :datetime
    add_column :polling_locations, :updated_at, :datetime
  end
end
