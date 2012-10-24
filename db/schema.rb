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

ActiveRecord::Schema.define(:version => 20121024164918) do

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.string   "vip_id"
    t.string   "version"
    t.boolean  "loaded",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "feeds", ["vip_id"], :name => "index_feeds_on_vip_id", :unique => true

  create_table "polling_locations", :force => true do |t|
    t.string  "name"
    t.string  "location_name"
    t.string  "line1",         :null => false
    t.string  "line2"
    t.string  "line3"
    t.string  "city",          :null => false
    t.string  "state",         :null => false
    t.string  "zip"
    t.string  "county"
    t.float   "latitude"
    t.float   "longitude"
    t.text    "properties"
    t.integer "feed_id"
  end

  add_index "polling_locations", ["state", "city", "zip", "line1"], :name => "index_polling_locations_on_address"

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
