# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_30_051619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytic_edq_results", force: :cascade do |t|
    t.integer "imo", null: false
    t.string "name", null: false
    t.float "foe", null: false
    t.float "init_lng_volume"
    t.float "unpumpable"
    t.float "cosuming_lng_of_laden_voyage"
    t.float "heel"
    t.float "edq"
    t.bigint "laden_voyage_id"
    t.bigint "ballast_voyage_id"
    t.boolean "published", default: false, null: false
    t.bigint "author_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "laden_voyage_no", null: false
    t.string "ballast_voyage_no", null: false
    t.index ["author_id"], name: "index_analytic_edq_results_on_author_id"
    t.index ["ballast_voyage_id"], name: "index_analytic_edq_results_on_ballast_voyage_id"
    t.index ["imo"], name: "index_analytic_edq_results_on_imo"
    t.index ["laden_voyage_id"], name: "index_analytic_edq_results_on_laden_voyage_id"
    t.index ["updated_by_id"], name: "index_analytic_edq_results_on_updated_by_id"
  end

  create_table "analytic_focs", force: :cascade do |t|
    t.integer "imo"
    t.float "speed"
    t.float "laden"
    t.float "ballast"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "created_by", null: false
    t.integer "updated_by", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_analytic_focs_on_created_by_id"
    t.index ["imo", "speed"], name: "index_analytic_focs_on_imo_and_speed", unique: true
    t.index ["imo"], name: "index_analytic_focs_on_imo"
    t.index ["updated_by_id"], name: "index_analytic_focs_on_updated_by_id"
  end

  create_table "analytic_genre_sim_channels", force: :cascade do |t|
    t.bigint "analytic_genres_id", null: false
    t.string "iso_std_name"
    t.index ["analytic_genres_id", "iso_std_name"], name: "analytic_genre_sim_channels_uniq_idx", unique: true
    t.index ["analytic_genres_id"], name: "index_analytic_genre_sim_channels_on_analytic_genres_id"
  end

  create_table "analytic_genres", force: :cascade do |t|
    t.integer "imo", null: false
    t.string "name", null: false
    t.boolean "active", default: false
    t.index ["imo", "name"], name: "analytic_genres_uniq_idx", unique: true
    t.index ["imo"], name: "index_analytic_genres_on_imo"
  end

  create_table "analytic_heel_results", force: :cascade do |t|
    t.string "type", null: false
    t.string "port_dept"
    t.string "port_arrival"
    t.string "pacific_route"
    t.datetime "etd", null: false
    t.datetime "eta", null: false
    t.float "estimated_distance", null: false
    t.float "voyage_duration", null: false
    t.float "required_speed", null: false
    t.float "estimated_daily_foc", null: false
    t.float "estimated_daily_foc_season_effect", null: false
    t.float "estimated_total_foc", null: false
    t.float "consuming_lng", null: false
    t.string "etd_time_zone"
    t.string "eta_time_zone"
    t.bigint "port_dept_id"
    t.bigint "port_arrival_id"
    t.bigint "master_route_id"
    t.index ["master_route_id"], name: "index_analytic_heel_results_on_master_route_id"
    t.index ["port_arrival_id"], name: "index_analytic_heel_results_on_port_arrival_id"
    t.index ["port_dept_id"], name: "index_analytic_heel_results_on_port_dept_id"
  end

  create_table "analytic_master_ports", force: :cascade do |t|
    t.string "name"
    t.integer "created_by"
    t.string "time_zone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.index ["created_by"], name: "index_analytic_master_ports_on_created_by"
    t.index ["created_by_id"], name: "index_analytic_master_ports_on_created_by_id"
    t.index ["updated_by_id"], name: "index_analytic_master_ports_on_updated_by_id"
  end

  create_table "analytic_master_routes", force: :cascade do |t|
    t.string "name"
    t.integer "created_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country_code"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.index ["created_by"], name: "index_analytic_master_routes_on_created_by"
    t.index ["created_by_id"], name: "index_analytic_master_routes_on_created_by_id"
    t.index ["updated_by_id"], name: "index_analytic_master_routes_on_updated_by_id"
  end

  create_table "analytic_report_files", force: :cascade do |t|
    t.integer "user_id"
    t.text "file_content_data"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_analytic_report_files_on_user_id"
  end

  create_table "analytic_routes", force: :cascade do |t|
    t.string "port_1"
    t.string "port_2"
    t.string "pacific_route"
    t.string "detail"
    t.integer "distance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "created_by", null: false
    t.integer "updated_by", null: false
    t.integer "port_1_id"
    t.integer "port_2_id"
    t.integer "master_route_id"
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_analytic_routes_on_created_by_id"
    t.index ["port_1", "port_2", "pacific_route"], name: "index_analytic_routes_on_port_1_and_port_2_and_pacific_route", unique: true
    t.index ["port_1", "port_2"], name: "index_analytic_routes_on_port_1_and_port_2"
    t.index ["port_1"], name: "index_analytic_routes_on_port_1"
    t.index ["port_1_id", "port_2_id", "pacific_route"], name: "port_route", unique: true
    t.index ["updated_by_id"], name: "index_analytic_routes_on_updated_by_id"
  end

  create_table "ecdis_points", force: :cascade do |t|
    t.bigint "ecdis_route_id", null: false
    t.string "name", default: "", null: false
    t.float "lat"
    t.float "lon"
    t.string "leg_type", default: "", null: false
    t.float "turn_radius"
    t.integer "chn_limit"
    t.float "planned_speed"
    t.float "speed_min"
    t.float "speed_max"
    t.float "course"
    t.float "length"
    t.date "do_plan"
    t.time "do_left"
    t.date "hfo_plan"
    t.time "hfo_left"
    t.date "eta_day"
    t.time "eta_time"
    t.datetime "original_eta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ecdis_route_id"], name: "index_ecdis_points_on_ecdis_route_id"
  end

  create_table "ecdis_routes", force: :cascade do |t|
    t.integer "imo", null: false
    t.string "format_file", default: "", null: false
    t.string "file_name", default: "", null: false
    t.datetime "etd"
    t.datetime "eta"
    t.float "max_power"
    t.float "speed"
    t.float "etd_wpno"
    t.float "eta_wpno"
    t.string "optimized", default: "", null: false
    t.float "budget"
    t.datetime "received_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "imported_checksum", default: "", null: false
    t.index ["imo"], name: "index_ecdis_routes_on_imo"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "activities", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tests", force: :cascade do |t|
    t.jsonb "result", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.text "crypted_token", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.integer "heading"
    t.float "speed_over_ground"
    t.datetime "last_ais_updated_at"
    t.integer "nav_status_code"
    t.integer "vessel_id"
    t.float "course"
    t.string "source"
    t.boolean "is_valid"
    t.boolean "need_to_scan"
    t.integer "imo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "csm_id"
    t.string "collection_type", default: "", null: false
    t.datetime "csm_created_at"
    t.index ["csm_created_at"], name: "index_trackings_on_csm_created_at"
    t.index ["imo"], name: "index_trackings_on_imo"
    t.index ["last_ais_updated_at"], name: "index_trackings_on_last_ais_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "fullname", default: "", null: false
    t.integer "role"
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vessel_destinations", force: :cascade do |t|
    t.integer "vessel_id"
    t.integer "csm_id"
    t.string "destination"
    t.float "draught"
    t.datetime "eta"
    t.datetime "last_ais_updated_at"
    t.integer "imo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "csm_created_at"
    t.string "source", default: "spire", null: false
    t.index ["imo"], name: "index_vessel_destinations_on_imo"
    t.index ["last_ais_updated_at"], name: "index_vessel_destinations_on_last_ais_updated_at"
  end

  create_table "vessels", force: :cascade do |t|
    t.integer "imo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "engine_type", default: "", null: false
    t.boolean "target", default: false
    t.string "ecdis_email", default: "", null: false
    t.datetime "last_port_departure_at"
    t.string "name", default: "", null: false
    t.string "error_code", default: "", null: false
    t.string "sim_data_type"
    t.text "genre_error_reporting_data"
    t.string "genre_error_code"
    t.index ["imo"], name: "index_vessels_on_imo", unique: true
  end

  add_foreign_key "analytic_edq_results", "analytic_heel_results", column: "ballast_voyage_id"
  add_foreign_key "analytic_edq_results", "analytic_heel_results", column: "laden_voyage_id"
  add_foreign_key "analytic_edq_results", "users", column: "author_id"
  add_foreign_key "analytic_edq_results", "users", column: "updated_by_id"
  add_foreign_key "analytic_heel_results", "analytic_master_ports", column: "port_arrival_id"
  add_foreign_key "analytic_heel_results", "analytic_master_ports", column: "port_dept_id"
  add_foreign_key "analytic_heel_results", "analytic_master_routes", column: "master_route_id"
end
