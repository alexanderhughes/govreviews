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

ActiveRecord::Schema.define(version: 20150508200116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "categories_public_entities", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "public_entity_id"
  end

  add_index "categories_public_entities", ["category_id"], name: "index_categories_public_entities_on_category_id", using: :btree
  add_index "categories_public_entities", ["public_entity_id"], name: "index_categories_public_entities_on_public_entity_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.integer  "rating"
    t.string   "review"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "public_entity_id"
    t.integer  "user_id"
  end

  create_table "public_entities", force: :cascade do |t|
    t.string   "name"
    t.string   "authority_level"
    t.string   "address"
    t.string   "description"
    t.string   "website"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "entity_type"
    t.integer  "superior_id"
    t.integer  "chief_id"
    t.string   "geotag"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
