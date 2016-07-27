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

ActiveRecord::Schema.define(version: 20160727222927) do

  create_table "Organizations_Users", id: false, force: :cascade do |t|
    t.integer "user_id",         null: false
    t.integer "organization_id", null: false
  end

  create_table "Teams_Users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
  end

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
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "branches_id"
    t.boolean  "tracked"
    t.integer  "hook_id"
    t.integer  "owner_id"
    t.index ["branches_id"], name: "index_repos_on_branches_id"
    t.index ["owner_id"], name: "index_repos_on_owner_id"
  end

  create_table "team_permissions", force: :cascade do |t|
    t.integer "team_id",    null: false
    t.integer "repo_id",    null: false
    t.string  "permission"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "remote_id"
    t.string   "name"
    t.string   "slug"
    t.string   "permission"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "login"
  end

end
