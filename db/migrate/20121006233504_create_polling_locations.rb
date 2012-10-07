class CreatePollingLocations < ActiveRecord::Migration
  def change
    create_table :polling_locations do |t|
      t.integer :feed_id
      t.integer :id_attribute
      t.text :address
      t.text :properties

      t.timestamps
    end
  end
end
