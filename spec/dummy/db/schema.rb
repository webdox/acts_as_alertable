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

ActiveRecord::Schema.define(version: 20180906185526) do

  create_table "acts_as_alertable_alert_alertables", force: :cascade do |t|
    t.integer  "alert_id"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "acts_as_alertable_alert_alertables", ["alert_id"], name: "index_acts_as_alertable_alert_alertables_on_alert_id"

  create_table "acts_as_alertable_alert_alerteds", force: :cascade do |t|
    t.integer  "alert_id"
    t.integer  "alerted_id"
    t.string   "alerted_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "acts_as_alertable_alert_alerteds", ["alert_id"], name: "index_acts_as_alertable_alert_alerteds_on_alert_id"

  create_table "acts_as_alertable_alerts", force: :cascade do |t|
    t.string   "alertable_type"
    t.string   "name"
    t.string   "observable_date"
    t.integer  "kind",                     default: 0
    t.string   "cron_format",              default: "0 0 1 * *"
    t.string   "alertables_custom_method"
    t.text     "notifications"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "alertable_articles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "release_date"
  end

  create_table "comments_users", force: :cascade do |t|
    t.integer "comment_id"
    t.integer "user_id"
  end

  add_index "comments_users", ["comment_id"], name: "index_comments_users_on_comment_id"
  add_index "comments_users", ["user_id"], name: "index_comments_users_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
