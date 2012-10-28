# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121028204551) do

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.string   "vip_id"
    t.string   "version"
    t.boolean  "loaded",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "feeds", ["url"], :name => "index_feeds_on_url", :unique => true

  create_table "polling_locations", :force => true do |t|
    t.string  "name"
    t.string  "location_name"
    t.string  "line1"
    t.string  "line2"
    t.string  "line3"
    t.string  "city"
    t.string  "state",         :limit => 2
    t.string  "zip",           :limit => 10
    t.string  "county"
    t.float   "latitude"
    t.float   "longitude"
    t.text    "properties"
    t.integer "feed_id"
    t.boolean "early_vote",                  :default => false
  end

  add_index "polling_locations", ["early_vote", "state", "city", "zip", "line1"], :name => "index_polling_locations_on_address"

  create_table "reviews", :force => true do |t|
    t.integer  "wait_time"
    t.boolean  "able_to_vote"
    t.integer  "rating"
    t.text     "comments"
    t.integer  "polling_location_id"
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "ip_address"
    t.string   "voted_day",           :limit => 5
    t.string   "voted_time",          :limit => 5
  end

  add_index "reviews", ["user_id", "polling_location_id"], :name => "index_reviews_on_user_id_and_polling_location_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "address"
    t.boolean  "wants_reminder",         :default => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
