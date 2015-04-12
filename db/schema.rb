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

ActiveRecord::Schema.define(version: 20150412100526) do

  create_table "credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "password_hash"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "credentials", ["user_id"], name: "index_credentials_on_user_id"
  add_index "credentials", ["username"], name: "index_credentials_on_username", unique: true

  create_table "evaluation_scales", force: :cascade do |t|
    t.text     "checkpoints"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "evaluation_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "klass_tests", force: :cascade do |t|
    t.integer  "teacher_id"
    t.date     "date"
    t.float    "total_score"
    t.integer  "evaluation_scale_id"
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "klass_tests", ["teacher_id"], name: "index_klass_tests_on_teacher_id"

  create_table "klasses", force: :cascade do |t|
    t.string   "name"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.float   "value"
    t.string  "as_string",  null: false
    t.boolean "is_counted", null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "klass_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "students", ["klass_id"], name: "index_students_on_klass_id"
  add_index "students", ["user_id", "klass_id"], name: "index_students_on_user_id_and_klass_id", unique: true
  add_index "students", ["user_id"], name: "index_students_on_user_id"

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "klass_id"
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teachers", ["klass_id"], name: "index_teachers_on_klass_id"
  add_index "teachers", ["subject_id"], name: "index_teachers_on_subject_id"
  add_index "teachers", ["user_id", "klass_id", "subject_id"], name: "index_teachers_on_user_id_and_klass_id_and_subject_id", unique: true
  add_index "teachers", ["user_id"], name: "index_teachers_on_user_id"

  create_table "user_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.integer  "user_group_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "sign_in_count",      default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

end
