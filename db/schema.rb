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

ActiveRecord::Schema.define(version: 20141128034123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "groups", force: true do |t|
    t.string  "name",         limit: 32,             null: false
    t.integer "system_flags", limit: 8,  default: 0, null: false
  end

  create_table "inspection_atoms", force: true do |t|
    t.integer "inspection_item_id"
    t.string  "title",              limit: 128,             null: false
    t.string  "code",               limit: 64,              null: false
    t.string  "unit",               limit: 16,              null: false
    t.integer "order_index",                    default: 0, null: false
    t.string  "data_type",          limit: 32,              null: false
    t.text    "data_descriptor",                            null: false
    t.string  "program_code",       limit: 64,              null: false
  end

  create_table "inspection_bundles", force: true do |t|
    t.string  "title",      limit: 128, null: false
    t.string  "group_name", limit: 64,  null: false
    t.string  "code",       limit: 64
    t.integer "item_ids",               null: false, array: true
  end

  create_table "inspection_items", force: true do |t|
    t.string "title",       limit: 128, null: false
    t.string "group_name",  limit: 64,  null: false
    t.string "code",        limit: 64
    t.string "sample_type", limit: 64,  null: false
  end

  create_table "issue_bundles", force: true do |t|
    t.integer  "issue_id",                             null: false
    t.integer  "inspection_bundle_id"
    t.integer  "inspection_item_ids",                  null: false, array: true
    t.boolean  "locked",               default: false, null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "issue_status_permissions", force: true do |t|
    t.integer "issue_status_id",              null: false
    t.integer "group_id",                     null: false
    t.integer "permission_flags", default: 0, null: false
    t.integer "issue_status_ids",             null: false, array: true
  end

  add_index "issue_status_permissions", ["issue_status_id", "group_id"], name: "index_issue_status_permissions_on_issue_status_id_and_group_id", unique: true, using: :btree

  create_table "issue_statuses", force: true do |t|
    t.string  "name",  limit: 64,             null: false
    t.integer "order",            default: 0, null: false
    t.string  "mode",  limit: 10,             null: false
  end

  create_table "issue_values", force: true do |t|
    t.integer  "issue_bundle_id",                null: false
    t.integer  "inspection_atom_id",             null: false
    t.string   "data",               limit: 128
    t.boolean  "override_error"
    t.string   "override_describe",  limit: 256
    t.integer  "editor_id"
    t.datetime "updated_at",                     null: false
  end

  create_table "issues", force: true do |t|
    t.integer  "profile_id",      null: false
    t.integer  "issue_status_id", null: false
    t.integer  "created_by_id",   null: false
    t.string   "access_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "identify",   limit: 32
    t.string   "firstname",  limit: 128, null: false
    t.string   "surname",    limit: 128, null: false
    t.string   "sex_flag",   limit: 1
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", force: true do |t|
    t.integer  "issue_id",               null: false
    t.string   "no",          limit: 64, null: false
    t.string   "sample_type", limit: 32, null: false
    t.integer  "quantity",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_groups", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "user_groups", ["user_id", "group_id"], name: "index_user_groups_on_user_id_and_group_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "username",        limit: 64,              null: false
    t.string   "hashed_password", limit: 128,             null: false
    t.string   "name",            limit: 128,             null: false
    t.string   "email",           limit: 128
    t.integer  "flags",                       default: 0, null: false
    t.datetime "lastlogin_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
