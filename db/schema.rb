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

ActiveRecord::Schema.define(version: 20151103103917) do

  create_table "characters", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "game_room_id",   limit: 4
    t.string   "name",           limit: 100
    t.string   "avatar_url",     limit: 255
    t.integer  "type",           limit: 4,   default: 0
    t.string   "signature",      limit: 255
    t.integer  "status",         limit: 4,   default: 1
    t.integer  "gender",         limit: 4,   default: 0
    t.integer  "sheet_mode",     limit: 4,   default: 0
    t.datetime "last_post_date"
    t.integer  "post_count",     limit: 4,   default: 0
    t.string   "slug",           limit: 255,             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "characters", ["game_room_id"], name: "index_characters_on_game_room_id", using: :btree
  add_index "characters", ["slug"], name: "index_characters_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "game_rooms", force: :cascade do |t|
    t.integer  "character_id",          limit: 4
    t.string   "name",                  limit: 255,             null: false
    t.string   "subtitle",              limit: 255
    t.string   "short_description",     limit: 255
    t.string   "description",           limit: 255
    t.string   "banner_url",            limit: 255
    t.string   "css",                   limit: 255
    t.string   "slug",                  limit: 255,             null: false
    t.integer  "status",                limit: 4,   default: 1
    t.string   "google_analytics_code", limit: 255
    t.boolean  "show_signature"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "game_rooms", ["character_id"], name: "index_game_rooms_on_character_id", using: :btree
  add_index "game_rooms", ["slug"], name: "index_game_rooms_on_slug", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "topic_id",     limit: 4
    t.integer  "character_id", limit: 4
    t.string   "message",      limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "posts", ["character_id"], name: "index_posts_on_character_id", using: :btree
  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.integer  "game_room_id",   limit: 4,               null: false
    t.integer  "character_id",   limit: 4
    t.string   "title",          limit: 100,             null: false
    t.string   "description",    limit: 255
    t.integer  "position",       limit: 4,   default: 0
    t.integer  "topic_group_id", limit: 4
    t.integer  "post_id",        limit: 4
    t.string   "slug",           limit: 255,             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "topics", ["character_id"], name: "index_topics_on_character_id", using: :btree
  add_index "topics", ["game_room_id"], name: "index_topics_on_game_room_id", using: :btree
  add_index "topics", ["post_id"], name: "index_topics_on_post_id", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

end
