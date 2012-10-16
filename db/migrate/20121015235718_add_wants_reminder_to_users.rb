class AddWantsReminderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wants_reminder, :boolean, :default => false
  end
end
