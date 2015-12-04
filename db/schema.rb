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

ActiveRecord::Schema.define(version: 20151105130550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.integer  "game_id"
    t.string   "name",           limit: 100
    t.string   "avatar"
    t.integer  "character_type",             default: 0, null: false
    t.string   "signature"
    t.integer  "status",                     default: 1, null: false
    t.integer  "gender",                     default: 0, null: false
    t.integer  "sheet_mode",                 default: 0, null: false
    t.datetime "last_post_date"
    t.integer  "post_count",                 default: 0
    t.string   "slug",                                   null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "characters", ["game_id"], name: "index_characters_on_game_id", using: :btree
  add_index "characters", ["slug"], name: "index_characters_on_slug", unique: true, using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "character_id",                         null: false
    t.string   "name",                                 null: false
    t.string   "subtitle"
    t.text     "short_description"
    t.text     "description"
    t.string   "banner"
    t.string   "css"
    t.string   "slug",                                 null: false
    t.integer  "status",                default: 1
    t.string   "google_analytics_code"
    t.boolean  "show_signature",        default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "games", ["character_id"], name: "index_games_on_character_id", using: :btree
  add_index "games", ["slug"], name: "index_games_on_slug", unique: true, using: :btree

  create_table "post_recipients", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "topic_id",     null: false
    t.integer  "character_id"
    t.text     "message",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "posts", ["character_id"], name: "index_posts_on_character_id", using: :btree
  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "game_id",                null: false
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "subscriptions", ["game_id"], name: "index_subscriptions_on_game_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "topic_groups", force: :cascade do |t|
    t.integer  "game_id",                            null: false
    t.string   "name",       limit: 100,             null: false
    t.integer  "position",               default: 0
    t.string   "slug",                               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "topic_groups", ["game_id"], name: "index_topic_groups_on_game_id", using: :btree
  add_index "topic_groups", ["slug"], name: "index_topic_groups_on_slug", unique: true, using: :btree

  create_table "topics", force: :cascade do |t|
    t.integer  "topic_group_id"
    t.integer  "game_id",                                null: false
    t.integer  "character_id"
    t.string   "title",          limit: 100,             null: false
    t.string   "description"
    t.integer  "position",                   default: 0
    t.integer  "post_id"
    t.string   "slug",                                   null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "topics", ["character_id"], name: "index_topics_on_character_id", using: :btree
  add_index "topics", ["game_id"], name: "index_topics_on_game_id", using: :btree
  add_index "topics", ["post_id"], name: "index_topics_on_post_id", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree
  add_index "topics", ["topic_group_id"], name: "index_topics_on_topic_group_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                       null: false
    t.string   "password",                                    null: false
    t.string   "name",            limit: 100,                 null: false
    t.string   "nickname",                                    null: false
    t.string   "secret_question"
    t.string   "secret_answer"
    t.boolean  "active",                      default: false
    t.string   "activation_code"
    t.string   "slug",                                        null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
