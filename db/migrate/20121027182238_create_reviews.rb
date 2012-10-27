class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.datetime :voted_at
      t.integer :wait_time
      t.boolean :able_to_vote
      t.integer :rating
      t.text :comments
      t.integer :polling_location_id
      t.integer :user_id

      t.timestamps
    end
  end
end
