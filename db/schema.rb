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

ActiveRecord::Schema.define(version: 20131124111324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "agencies", force: true do |t|
    t.string "name"
    t.string "url"
    t.string "timezone"
    t.string "lang"
    t.string "phone"
    t.string "fare_url"
  end

  create_table "calendars", id: false, force: true do |t|
    t.integer "service_id"
    t.boolean "sunday"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "calendars", ["service_id"], :name => "index_calendars_on_service_id"

  create_table "routes", force: true do |t|
    t.integer "agency_id",        limit: 2
    t.string  "route_short_name"
    t.string  "route_long_name"
    t.string  "route_desc"
    t.integer "route_type",       limit: 2
    t.string  "route_color"
  end

  create_table "shape_paths", force: true do |t|
    t.integer "shape_id"
    t.spatial "path",     limit: {:srid=>4326, :type=>"line_string", :geographic=>true}
  end

  add_index "shape_paths", ["path"], :name => "paths_geo_index", :spatial => true
  add_index "shape_paths", ["shape_id"], :name => "index_shape_paths_on_shape_id"

  create_table "shapes", id: false, force: true do |t|
    t.integer "id"
    t.float   "shape_pt_lat"
    t.float   "shape_pt_lon"
    t.integer "shape_pt_sequence"
  end

  add_index "shapes", ["id", "shape_pt_sequence"], :name => "index_shapes_on_id_and_shape_pt_sequence"

  create_table "stop_cities", force: true do |t|
    t.integer "stop_id"
    t.string  "city"
    t.string  "address"
    t.string  "city_hebrew"
  end

  add_index "stop_cities", ["stop_id"], :name => "index_stop_cities_on_stop_id"

  create_table "stop_paths", force: true do |t|
    t.string  "trip_id"
    t.spatial "points",  limit: {:srid=>4326, :type=>"multi_point", :geographic=>true}
  end

  add_index "stop_paths", ["points"], :name => "index_stop_paths_on_points", :spatial => true

  create_table "stop_times", id: false, force: true do |t|
    t.string  "trip_id"
    t.string  "arrival_time"
    t.string  "departure_time"
    t.integer "stop_id"
    t.integer "stop_sequence"
    t.integer "pickup_type",    limit: 2
    t.integer "drop_off_type",  limit: 2
  end

  add_index "stop_times", ["stop_id"], :name => "index_stop_times_on_stop_id"
  add_index "stop_times", ["trip_id"], :name => "index_stop_times_on_trip_id"

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

  add_index "trips", ["id"], :name => "index_trips_on_id"
  add_index "trips", ["route_id"], :name => "index_trips_on_route_id"
  add_index "trips", ["service_id"], :name => "index_trips_on_service_id"
  add_index "trips", ["shape_id"], :name => "index_trips_on_shape_id"

end
