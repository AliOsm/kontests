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

ActiveRecord::Schema.define(version: 2020_04_02_171928) do

  create_table "all", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "site"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "at_coder", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "rated_range"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "code_chef", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "codeforces", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "codeforces_gym", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.integer "difficulty"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "cs_academy", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "hacker_earth", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "type_"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "hacker_rank", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "type_"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "joins", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "how", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kick_start", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "last_updates", force: :cascade do |t|
    t.string "site"
    t.datetime "date"
  end

  create_table "leet_code", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

  create_table "suggests", force: :cascade do |t|
    t.string "site", null: false
    t.string "email", default: ""
    t.text "message", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "top_coder", id: false, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.string "in_24_hours"
    t.string "status"
  end

end
