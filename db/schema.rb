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

ActiveRecord::Schema[7.0].define(version: 2025_01_22_203055) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "title", null: false
    t.string "description"
    t.string "image"
    t.uuid "deck_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "choices"
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "deck_session_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "deck_session_id", null: false
    t.string "name", null: false
    t.string "title", null: false
    t.string "description"
    t.string "image"
    t.boolean "answered", default: false
    t.boolean "correct"
    t.integer "answered_choice"
    t.jsonb "choices", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_session_id"], name: "index_deck_session_cards_on_deck_session_id"
  end

  create_table "deck_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "deck_id"
    t.uuid "user_id", null: false
    t.jsonb "choices", default: [], null: false
    t.jsonb "selected_choices", default: []
    t.datetime "completed_at"
    t.datetime "started_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "current_card_index", default: 0, null: false
    t.integer "total_cards", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_deck_sessions_on_deck_id"
    t.index ["user_id"], name: "index_deck_sessions_on_user_id"
  end

  create_table "decks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.uuid "account_id"
    t.uuid "folder_id"
    t.boolean "active", default: true
    t.index ["account_id"], name: "index_decks_on_account_id"
    t.index ["folder_id"], name: "index_decks_on_folder_id"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "decks_folders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "deck_id", null: false
    t.uuid "folder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_decks_folders_on_deck_id"
    t.index ["folder_id"], name: "index_decks_folders_on_folder_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "folders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.uuid "user_id"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "correct_answers"
    t.integer "total_cards"
    t.jsonb "cards"
    t.string "timespan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "deck_session_id", null: false
    t.index ["deck_session_id"], name: "index_results_on_deck_session_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "department_id"
    t.uuid "account_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "deck_session_cards", "deck_sessions"
  add_foreign_key "deck_sessions", "decks"
  add_foreign_key "deck_sessions", "users"
  add_foreign_key "decks", "accounts"
  add_foreign_key "decks", "folders"
  add_foreign_key "decks", "users"
  add_foreign_key "decks_folders", "decks"
  add_foreign_key "decks_folders", "folders"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "folders", "users"
  add_foreign_key "results", "deck_sessions"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "departments"
end
