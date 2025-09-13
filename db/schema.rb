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

ActiveRecord::Schema[8.0].define(version: 2025_09_13_210901) do
  create_table "archives", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "archives_name_idx"
    t.index ["owner_id"], name: "index_archives_on_owner_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "tag", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "characters_email_address_uniqueness_idx", unique: true
    t.index ["tag"], name: "characters_tag_uniqueness_idx", unique: true
  end

  create_table "padlocks", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "keyable_type"
    t.integer "keyable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "keyable_id", "keyable_type"], name: "padlocks_character_keyable_uniqueness_idx", unique: true
    t.index ["character_id"], name: "index_padlocks_on_character_id"
    t.index ["keyable_type", "keyable_id"], name: "index_padlocks_on_keyable"
  end

  create_table "password_keys", force: :cascade do |t|
    t.string "password_digest"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_sessions_on_character_id"
  end

  add_foreign_key "archives", "characters", column: "owner_id"
  add_foreign_key "padlocks", "characters"
  add_foreign_key "sessions", "characters"
end
