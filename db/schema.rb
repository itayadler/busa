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

ActiveRecord::Schema.define(version: 20130916190206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: true do |t|
    t.string "name"
    t.string "url"
    t.string "timezone"
    t.string "lang"
    t.string "phone"
    t.string "fare_url"
  end

  create_table "stop_times", id: false, force: true do |t|
    t.string "id"
    t.string "arrival_time"
    t.string "departure_time"
    t.string "stop_id"
    t.string "stop_sequence"
    t.string "pickup_type"
    t.string "drop_off_type"
  end

end
