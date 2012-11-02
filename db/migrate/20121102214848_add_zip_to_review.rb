class AddZipToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :zip, :string
  end
end
