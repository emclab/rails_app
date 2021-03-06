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

ActiveRecord::Schema.define(:version => 20121103200832) do

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sys_action_on_tables", :force => true do |t|
    t.string   "action"
    t.string   "table_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sys_action_on_tables", ["action"], :name => "index_sys_action_on_tables_on_action"
  add_index "sys_action_on_tables", ["table_name"], :name => "index_sys_action_on_tables_on_table_name"

  create_table "sys_logs", :force => true do |t|
    t.datetime "log_date"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_ip"
    t.string   "action_logged"
  end

  create_table "sys_module_mappings", :force => true do |t|
    t.integer  "sys_module_id"
    t.integer  "sys_user_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "sys_modules", :force => true do |t|
    t.string   "module_name"
    t.string   "module_group_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "sys_user_groups", :force => true do |t|
    t.string   "user_group_name"
    t.string   "short_note"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sys_user_rights", :force => true do |t|
    t.integer  "sys_action_on_table_id"
    t.integer  "sys_user_group_id"
    t.string   "matching_column_name"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "accessible_column_name"
  end

  add_index "sys_user_rights", ["sys_action_on_table_id"], :name => "index_sys_user_rights_on_sys_action_on_table_id"
  add_index "sys_user_rights", ["sys_user_group_id"], :name => "index_sys_user_rights_on_sys_user_group_id"

  create_table "user_levels", :force => true do |t|
    t.integer  "user_id"
    t.string   "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "manager"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "status",             :default => "active"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

end
