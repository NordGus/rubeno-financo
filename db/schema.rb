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

ActiveRecord::Schema[8.1].define(version: 2025_11_12_002232) do
  create_table "account_config_histories", force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "at"
    t.decimal "balance", precision: 16, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_config_histories_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "archive_id", null: false
    t.boolean "archived", default: false, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "multi", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "name", null: false
    t.integer "parent_id"
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_id"], name: "index_accounts_on_archive_id"
    t.index ["archived"], name: "accounts_archived_idx"
    t.index ["currency"], name: "accounts_currency_idx"
    t.index ["deleted_at"], name: "accounts_deleted_at_idx"
    t.index ["parent_id"], name: "accounts_parent_idx"
    t.index ["type"], name: "accounts_type_idx"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "archive_access_keys", force: :cascade do |t|
    t.integer "archive_id", null: false
    t.boolean "can_edit", default: false, null: false
    t.boolean "can_view", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_id", "owner_id"], name: "single_owner_key_per_archive_constraint_idx", unique: true
    t.index ["archive_id"], name: "index_archive_access_keys_on_archive_id"
    t.index ["can_edit"], name: "archive_access_keys_can_edit_idx"
    t.index ["can_view"], name: "archive_access_key_can_view_idx"
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

  create_table "file_system_items", force: :cascade do |t|
    t.integer "archive_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.integer "parentable_id", null: false
    t.string "parentable_type", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.string "version", null: false
    t.index ["archive_id"], name: "index_file_system_items_on_archive_id"
    t.index ["deleted_at"], name: "file_system_items_deleted_at_index"
    t.index ["name", "parentable_type", "parentable_id"], name: "file_system_items_name_uniqueness_index", unique: true, where: "parentable_type != 'FileSystem::Item::File'"
    t.index ["name"], name: "index_file_system_items_on_name"
    t.index ["parentable_type", "parentable_id"], name: "file_system_items_mount_uniqueness_index", unique: true, where: "parentable_type = 'FileSystem::Item::Mount'"
    t.index ["parentable_type", "parentable_id"], name: "file_system_items_parentable_index"
    t.index ["type"], name: "file_system_items_type_index"
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

  create_table "transactions", force: :cascade do |t|
    t.integer "archive_id", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.datetime "deleted_at"
    t.date "executed_at"
    t.decimal "from_amount", precision: 16, scale: 2, null: false
    t.integer "from_id", null: false
    t.integer "from_parent_id"
    t.date "issued_at", null: false
    t.decimal "to_amount", precision: 16, scale: 2, null: false
    t.integer "to_id", null: false
    t.integer "to_parent_id"
    t.datetime "updated_at", null: false
    t.index ["archive_id"], name: "index_transactions_on_archive_id"
    t.index ["deleted_at"], name: "transactions_deleted_at_index"
    t.index ["executed_at"], name: "transactions_executed_at_idx"
    t.index ["from_id"], name: "index_transactions_on_from_id"
    t.index ["from_parent_id"], name: "index_transactions_on_from_parent_id"
    t.index ["issued_at"], name: "transactions_issued_at_idx"
    t.index ["to_id"], name: "index_transactions_on_to_id"
    t.index ["to_parent_id"], name: "index_transactions_on_to_parent_id"
  end

  add_foreign_key "account_config_histories", "accounts"
  add_foreign_key "accounts", "archives"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "archive_access_keys", "archives"
  add_foreign_key "archive_access_keys", "characters", column: "owner_id"
  add_foreign_key "archives", "characters", column: "owner_id"
  add_foreign_key "file_system_items", "archives"
  add_foreign_key "padlocks", "characters"
  add_foreign_key "sessions", "characters"
  add_foreign_key "transactions", "accounts", column: "from_id"
  add_foreign_key "transactions", "accounts", column: "from_parent_id"
  add_foreign_key "transactions", "accounts", column: "to_id"
  add_foreign_key "transactions", "accounts", column: "to_parent_id"
  add_foreign_key "transactions", "archives"
end
