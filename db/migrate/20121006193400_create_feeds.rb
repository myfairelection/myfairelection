class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :vip_id
      t.string :version
      t.boolean :loaded, :default => false

      t.timestamps
    end
    add_index :feeds, :vip_id, :unique => true
  end
end
