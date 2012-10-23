class PollingLocationZipCanBeNull < ActiveRecord::Migration
  def up
    change_column :polling_locations, :zip, :string, :null => true
  end

  def down
    PollingLocation.where(:zip => nil).each do |pl|
      pl.zip = "00000"
    end
    change_column :polling_locations, :zip, :string, :null => false
  end
end
