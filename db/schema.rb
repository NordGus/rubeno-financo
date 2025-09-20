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

ActiveRecord::Schema[8.1].define(version: 2025_09_20_142757) do
  create_table "archive_access_keys", force: :cascade do |t|
    t.integer "archive_id", null: false
    t.datetime "can_edit_since"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.integer "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_id"], name: "index_archive_access_keys_on_archive_id"
    t.index ["can_edit_since"], name: "archive_access_key_can_edit_since_idx"
    t.index ["expires_at"], name: "archive_access_key_expires_at_idx"
    t.index ["owner_id"], name: "index_archive_access_keys_on_owner_id"
  end

  create_table "archives", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "archives_name_idx"
    t.index ["owner_id"], name: "index_archives_on_owner_id"
  end

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "tag", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "characters_email_address_uniqueness_idx", unique: true
    t.index ["tag"], name: "characters_tag_uniqueness_idx", unique: true
  end

  create_table "padlocks", force: :cascade do |t|
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "keyable_id"
    t.string "keyable_type"
    t.datetime "updated_at", null: false
    t.index ["character_id", "keyable_id", "keyable_type"], name: "padlocks_character_keyable_uniqueness_idx", unique: true
    t.index ["character_id"], name: "index_padlocks_on_character_id"
    t.index ["keyable_type", "keyable_id"], name: "index_padlocks_on_keyable"
  end

  create_table "password_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_sign_in_at"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "archive_id"
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["character_id"], name: "index_sessions_on_character_id"
    t.index ["token"], name: "sessions_token_uniqueness_idx", unique: true
  end

  add_foreign_key "archive_access_keys", "archives"
  add_foreign_key "archive_access_keys", "characters", column: "owner_id"
  add_foreign_key "archives", "characters", column: "owner_id"
  add_foreign_key "padlocks", "characters"
  add_foreign_key "sessions", "characters"
end
