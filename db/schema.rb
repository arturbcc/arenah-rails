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

ActiveRecord::Schema.define(version: 20180127125757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id"
    t.string "name", limit: 100
    t.string "avatar"
    t.integer "character_type", default: 0, null: false
    t.string "signature"
    t.integer "status", default: 1, null: false
    t.integer "gender", default: 0, null: false
    t.integer "sheet_mode", default: 0, null: false
    t.datetime "last_post_date"
    t.integer "post_count", default: 0
    t.string "slug", null: false
    t.jsonb "raw_sheet", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_characters_on_game_id"
    t.index ["raw_sheet"], name: "index_characters_on_raw_sheet", using: :gin
    t.index ["slug"], name: "index_characters_on_slug", unique: true
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "name", limit: 45, null: false
    t.string "subtitle"
    t.text "short_description"
    t.text "description"
    t.string "banner"
    t.string "css"
    t.string "slug", null: false
    t.integer "status", default: 1
    t.string "google_analytics_code"
    t.boolean "show_signature", default: true
    t.jsonb "raw_system", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_games_on_character_id"
    t.index ["raw_system"], name: "index_games_on_raw_system", using: :gin
    t.index ["slug"], name: "index_games_on_slug", unique: true
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "from", default: 0
    t.integer "to", null: false
    t.string "body"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from"], name: "index_messages_on_from"
    t.index ["to"], name: "index_messages_on_to"
  end

  create_table "post_recipients", id: :serial, force: :cascade do |t|
    t.integer "post_id"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "topic_id", null: false
    t.integer "character_id"
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_posts_on_character_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_subscriptions_on_game_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "topic_groups", id: :serial, force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "name", limit: 100, null: false
    t.integer "position", default: 0
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_topics_destination", default: 1, null: false
    t.index ["game_id"], name: "index_topic_groups_on_game_id"
    t.index ["slug"], name: "index_topic_groups_on_slug", unique: true
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.integer "topic_group_id"
    t.integer "game_id", null: false
    t.integer "character_id"
    t.string "title", limit: 100, null: false
    t.string "description"
    t.integer "position", default: 0
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "destination", default: 1, null: false
    t.index ["character_id"], name: "index_topics_on_character_id"
    t.index ["game_id"], name: "index_topics_on_game_id"
    t.index ["slug"], name: "index_topics_on_slug", unique: true
    t.index ["topic_group_id"], name: "index_topics_on_topic_group_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "legacy_password"
    t.string "name", limit: 100, null: false
    t.boolean "active", default: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

end
