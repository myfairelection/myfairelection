class ChangeDateInReview < ActiveRecord::Migration
  def up
    add_column :reviews, :voted_day, :string, :limit => 5
    add_column :reviews, :voted_time, :string, :limit => 5
    remove_column :reviews, :voted_at
  end

  def down
    remove_column :reviews, :voted_day
    remove_column :reviews, :voted_time
    add_column :reviews, :voted_at, :datetime
  end
end
