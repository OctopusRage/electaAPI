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

ActiveRecord::Schema.define(version: 20161103201746) do

  create_table "file_uploads", force: :cascade do |t|
    t.string   "raw"
    t.string   "hash_id"
    t.string   "name"
    t.string   "ext"
    t.integer  "uploader_id"
    t.string   "uploader_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "url"
  end

  create_table "priviledges", force: :cascade do |t|
    t.string   "access"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards", force: :cascade do |t|
    t.integer  "rewarder_id"
    t.string   "rewarder_type"
    t.string   "description"
    t.string   "reward_type"
    t.string   "reward_pict_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "user_followers", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_type_priviledges", force: :cascade do |t|
    t.integer  "priviledge_id"
    t.integer  "user_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_type_priviledges", ["priviledge_id"], name: "index_user_type_priviledges_on_priviledge_id"
  add_index "user_type_priviledges", ["user_type_id"], name: "index_user_type_priviledges_on_user_type_id"

  create_table "user_types", force: :cascade do |t|
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_vote_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vote_option_before"
    t.integer  "vote_option_after"
    t.integer  "vote_id"
    t.string   "action"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "user_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vote_option_id"
    t.integer  "vote_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_votes", ["user_id"], name: "index_user_votes_on_user_id"
  add_index "user_votes", ["vote_id"], name: "index_user_votes_on_vote_id"
  add_index "user_votes", ["vote_option_id"], name: "index_user_votes_on_vote_option_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "authentication_token"
    t.string   "city"
    t.string   "grade"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "degree"
    t.string   "job"
    t.date     "date_of_birth"
    t.string   "province"
    t.string   "phone_number"
    t.string   "avatar_url"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_type_id"
    t.boolean  "verified",               default: false
    t.string   "gender"
    t.datetime "last_login_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["user_type_id"], name: "index_users_on_user_type_id"

  create_table "vote_categories", force: :cascade do |t|
    t.string   "category"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "vote_options", force: :cascade do |t|
    t.string   "options"
    t.integer  "vote_id"
    t.string   "user_vote_pict"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "vote_options", ["vote_id"], name: "index_vote_options_on_vote_id"

  create_table "vote_subscribers", force: :cascade do |t|
    t.integer  "vote_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "vote_subscribers", ["user_id"], name: "index_vote_subscribers_on_user_id"
  add_index "vote_subscribers", ["vote_id"], name: "index_vote_subscribers_on_vote_id"

  create_table "votes", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "category_id"
    t.date     "started_at"
    t.date     "ended_at"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "vote_pict_url"
    t.string   "status",        default: "open"
  end

  add_index "votes", ["category_id"], name: "index_votes_on_category_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
