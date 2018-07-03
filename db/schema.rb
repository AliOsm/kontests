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

ActiveRecord::Schema.define(version: 2018_07_03_055732) do

  create_table "a2oj", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "name"
    t.string "owner"
    t.string "start_time"
    t.string "before_start"
    t.string "duration"
    t.string "registrants"
    t.string "type_"
    t.string "registration"
    t.index ["code"], name: "index_a2oj_on_code", unique: true
  end

  create_table "at_coder", id: false, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "start_time"
    t.string "duration"
    t.string "participate"
    t.string "rated"
    t.index ["code"], name: "index_at_coder_on_code", unique: true
  end

  create_table "code_chef", id: false, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "start_time"
    t.string "end_time"
    t.string "duration"
    t.index ["code"], name: "index_code_chef_on_code", unique: true
  end

  create_table "codeforces", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "name"
    t.string "start_time"
    t.string "duration"
    t.index ["code"], name: "index_codeforces_on_code", unique: true
  end

  create_table "codeforces_gym", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "name"
    t.string "start_time"
    t.string "duration"
    t.integer "difficulty"
    t.index ["code"], name: "index_codeforces_gym_on_code", unique: true
  end

  create_table "cs_academy", id: false, force: :cascade do |t|
    t.string "name"
    t.string "start_time"
    t.string "duration"
  end

  create_table "suggests", force: :cascade do |t|
    t.string "site", null: false
    t.string "email", default: ""
    t.text "message", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
