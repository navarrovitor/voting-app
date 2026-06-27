# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contestants", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "singing_enabled", default: true, null: false
    t.boolean "costume_enabled", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.boolean "present", default: false, null: false
    t.index ["code"], name: "index_contestants_on_code", unique: true
  end

  create_table "guests", force: :cascade do |t|
    t.string "email", null: false
    t.string "auth_token"
    t.datetime "token_expires_at"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
    t.index ["session_token"], name: "index_guests_on_session_token", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "guest_id", null: false
    t.bigint "contestant_id", null: false
    t.string "category", null: false
    t.integer "rank", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contestant_id"], name: "index_votes_on_contestant_id"
    t.index ["guest_id", "category", "contestant_id"], name: "index_votes_on_guest_id_and_category_and_contestant_id", unique: true
    t.index ["guest_id", "category", "rank"], name: "index_votes_on_guest_id_and_category_and_rank", unique: true
    t.index ["guest_id"], name: "index_votes_on_guest_id"
  end

  add_foreign_key "votes", "contestants"
  add_foreign_key "votes", "guests"
end
