class RemoveIndexFromFeeds < ActiveRecord::Migration
  def up
    remove_index :feeds, :vip_id
    add_index :feeds, :url, :unique => true
  end

  def down
    add_index :feeds, :vip_id, :unique => true
    remove_index :feeds, :url
  end
end
