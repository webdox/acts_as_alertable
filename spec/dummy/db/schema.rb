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

ActiveRecord::Schema.define(version: 20180905211311) do

  create_table "acts_as_alertable_alert_alerteds", force: :cascade do |t|
    t.integer  "alert_id"
    t.integer  "alerted_id"
    t.string   "alerted_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "acts_as_alertable_alert_alerteds", ["alert_id"], name: "index_acts_as_alertable_alert_alerteds_on_alert_id"

  create_table "acts_as_alertable_alerts", force: :cascade do |t|
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.string   "observable_date"
    t.integer  "kind",            default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "alertable_articles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
