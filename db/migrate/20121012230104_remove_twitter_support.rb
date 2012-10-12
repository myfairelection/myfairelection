class RemoveTwitterSupport < ActiveRecord::Migration
  def up
    User.where(email: "").each { |u| u.destroy }
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :username
    remove_index :users, :name => "index_users_on_identity"
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  end

  def down
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :username, :string
    remove_index "users", :name =>"index_users_on_email" 
    add_index "users", ["email", "provider", "uid"], :name => "index_users_on_identity", :unique => true
  end
end
