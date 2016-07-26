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

ActiveRecord::Schema.define(version: 20160726134311) do

  create_table "branches", force: :cascade do |t|
    t.integer  "repo_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repo_id"], name: "index_branches_on_repo_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "login"
  end

  create_table "owners", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "ownerable_type"
    t.integer  "ownerable_id"
    t.index ["ownerable_type", "ownerable_id"], name: "index_owners_on_ownerable_type_and_ownerable_id"
  end

  create_table "repos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "branches_id"
    t.string   "owner"
    t.boolean  "tracked"
    t.integer  "hook_id"
    t.index ["branches_id"], name: "index_repos_on_branches_id"
    t.index ["user_id"], name: "index_repos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "repos_id"
    t.index ["repos_id"], name: "index_users_on_repos_id"
  end

end
