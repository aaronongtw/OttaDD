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

ActiveRecord::Schema.define(version: 20150604061133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "databases", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tablenum"
    t.integer  "user_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.string   "fieldtype"
    t.integer  "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.string   "name"
    t.integer  "database_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "relationships_tables", force: :cascade do |t|
    t.integer "relationship_id"
    t.integer "table_id"
  end

  create_table "table_relations", force: :cascade do |t|
    t.integer  "table_id"
    t.string   "relationship"
    t.string   "through"
    t.string   "table_to"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.integer  "database_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "fieldnum"
    t.string   "relation"
    t.string   "relativename"
    t.string   "through"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "password_digest"
    t.boolean "admin",           default: false
  end

end
