class CreateStates < ActiveRecord::Migration
  def change
    create_table :state_map_data, :id => false do |t|
      t.string :name, :limit => 2
      t.float :wait_time
      t.float :rating
      t.integer :n
    end
  end
end
