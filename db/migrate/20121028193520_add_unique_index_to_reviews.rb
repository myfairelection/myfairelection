class AddUniqueIndexToReviews < ActiveRecord::Migration
  def change
    add_index :reviews, [:user_id, :polling_location_id], unique: true
  end
end
