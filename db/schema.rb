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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180205051208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "read_only",  default: false
  end

  add_index "access_tokens", ["user_id"], name: "index_access_tokens_on_user_id", using: :btree

  create_table "device_access_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "sequence"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "device_access_tokens", ["device_id"], name: "index_device_access_tokens_on_device_id", using: :btree
  add_index "device_access_tokens", ["token"], name: "index_device_access_tokens_on_token", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer  "last_used_key_sequence", default: -1,    null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id"
    t.boolean  "key_rotation_enabled"
    t.string   "name"
    t.string   "uuid"
    t.boolean  "linked",                 default: false, null: false
    t.string   "stream_type"
    t.text     "description"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", unique: true, using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "log_datum_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "images", ["log_datum_id"], name: "index_images_on_log_datum_id", using: :btree

  create_table "log_data", force: :cascade do |t|
    t.integer  "device_id"
    t.json     "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "log_data", ["device_id"], name: "index_log_data_on_device_id", using: :btree

  create_table "system_configs", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "system_configs", ["key"], name: "index_system_configs_on_key", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "webhooks", force: :cascade do |t|
    t.string   "url",                       null: false
    t.boolean  "active",     default: true, null: false
    t.integer  "device_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "secret"
  end

  add_index "webhooks", ["device_id"], name: "index_webhooks_on_device_id", using: :btree

  add_foreign_key "access_tokens", "users"
  add_foreign_key "device_access_tokens", "devices"
  add_foreign_key "devices", "users"
  add_foreign_key "images", "log_data"
  add_foreign_key "log_data", "devices"
  add_foreign_key "webhooks", "devices"
end
