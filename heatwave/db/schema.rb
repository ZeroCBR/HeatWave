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

ActiveRecord::Schema.define(version: 20150913050319) do

  create_table "locations", force: :cascade do |t|
    t.string   "name",                                null: false
    t.decimal  "jan_average", precision: 4, scale: 1, null: false
    t.decimal  "feb_average", precision: 4, scale: 1, null: false
    t.decimal  "mar_average", precision: 4, scale: 1, null: false
    t.decimal  "apr_average", precision: 4, scale: 1, null: false
    t.decimal  "jun_average", precision: 4, scale: 1, null: false
    t.decimal  "jul_average", precision: 4, scale: 1, null: false
    t.decimal  "aug_average", precision: 4, scale: 1, null: false
    t.decimal  "sep_average", precision: 4, scale: 1, null: false
    t.decimal  "oct_average", precision: 4, scale: 1, null: false
    t.decimal  "nov_average", precision: 4, scale: 1, null: false
    t.decimal  "dec_average", precision: 4, scale: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "weathers", force: :cascade do |t|
    t.integer  "location_id", limit: 1, null: false
    t.integer  "high_temp",   limit: 1, null: false
    t.date     "date",                  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false

  create_table "attributes", force: :cascade do |t|
    t.string   "name"
    t.string   "annotation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.string   "comment"
    t.boolean  "responded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string   "name"
    t.string   "annotation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "f_name"
    t.string   "l_name"
    t.string   "password"
    t.boolean  "adminAccess"
    t.string   "gender"
    t.string   "address"
    t.string   "phone"
    t.integer  "age"
    t.string   "email"
    t.boolean  "suscribed"
    t.date     "birthday"
    t.integer  "postcode"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end
  end
end
