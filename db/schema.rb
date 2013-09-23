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

ActiveRecord::Schema.define(version: 20130923175348) do

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

  create_table "routes", force: true do |t|
    t.string "agency_id"
    t.string "route_short_name"
    t.string "route_long_name"
    t.string "route_desc"
    t.string "route_type"
    t.string "route_color"
  end

  create_table "shapes", id: false, force: true do |t|
    t.integer "id"
    t.float   "shape_pt_lat"
    t.float   "shape_pt_lon"
    t.integer "shape_pt_sequence"
  end

  add_index "shapes", ["id", "shape_pt_sequence"], name: "index_shapes_on_id_and_shape_pt_sequence", using: :btree

  create_table "stop_times", id: false, force: true do |t|
    t.string "id"
    t.string "arrival_time"
    t.string "departure_time"
    t.string "stop_id"
    t.string "stop_sequence"
    t.string "pickup_type"
    t.string "drop_off_type"
  end

  create_table "stops", force: true do |t|
    t.integer "code"
    t.string  "name"
    t.string  "description"
    t.float   "lat"
    t.float   "lon"
    t.integer "location_type"
    t.string  "parent_station"
  end

  create_table "trips", id: false, force: true do |t|
    t.integer "route_id"
    t.integer "service_id"
    t.string  "id"
    t.integer "direction_id"
    t.integer "shape_id"
  end

end
