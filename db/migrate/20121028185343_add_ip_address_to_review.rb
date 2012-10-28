class AddIpAddressToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :ip_address, :string
  end
end
