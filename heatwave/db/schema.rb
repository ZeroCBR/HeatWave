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

ActiveRecord::Schema.define(version: 20151007035200) do

  create_table "attributes", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "annotation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attributes_rules", force: :cascade do |t|
    t.integer  "attribute_id", null: false
    t.integer  "rule_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "content",    null: false
    t.string   "comment"
    t.boolean  "responded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",                               null: false
    t.decimal  "jan_mean",   precision: 4, scale: 1, null: false
    t.decimal  "feb_mean",   precision: 4, scale: 1, null: false
    t.decimal  "mar_mean",   precision: 4, scale: 1, null: false
    t.decimal  "apr_mean",   precision: 4, scale: 1, null: false
    t.decimal  "may_mean",   precision: 4, scale: 1, null: false
    t.decimal  "jun_mean",   precision: 4, scale: 1, null: false
    t.decimal  "jul_mean",   precision: 4, scale: 1, null: false
    t.decimal  "aug_mean",   precision: 4, scale: 1, null: false
    t.decimal  "sep_mean",   precision: 4, scale: 1, null: false
    t.decimal  "oct_mean",   precision: 4, scale: 1, null: false
    t.decimal  "nov_mean",   precision: 4, scale: 1, null: false
    t.decimal  "dec_mean",   precision: 4, scale: 1, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "weather_id", null: false
    t.integer  "rule_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "send_time"
    t.string   "contents",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.boolean  "activated",             default: false, null: false
    t.integer  "delta",       limit: 1,                 null: false
    t.integer  "duration",    limit: 1,                 null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "key_advice",                            null: false
    t.text     "full_advice",                           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "f_name",                              null: false
    t.string   "l_name",                              null: false
    t.boolean  "admin_access",                        null: false
    t.string   "gender",                              null: false
    t.string   "phone"
    t.integer  "age",                                 null: false
    t.string   "message_type"
    t.integer  "location_id",                         null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_attributes", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "attribute_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "weathers", force: :cascade do |t|
    t.integer  "location_id",           null: false
    t.integer  "high_temp",   limit: 1, null: false
    t.date     "date",                  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
