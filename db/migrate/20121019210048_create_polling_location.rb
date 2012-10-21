class CreatePollingLocation < ActiveRecord::Migration
  def change
    create_table :polling_locations do |t|
      #  attr_accessible :name, :location_name, :line1, :line2, :line3, :city, :state, :zip, :county, :latitude, :longitude, :properties

      t.string :name
      t.string :location_name
      t.string :line1, :null => false
      t.string :line2
      t.string :line3
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :zip, :null => false
      t.string :county
      t.float :latitude
      t.float :longitude
      t.text :properties #will be json
    end
  end
end
