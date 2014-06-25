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

ActiveRecord::Schema.define(version: 20140607094604) do

  create_table "auto_parameters", force: true do |t|
    t.integer  "automation_id"
    t.integer  "parameter_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
  end

  create_table "automations", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "part_id"
    t.integer  "export_type_id"
    t.integer  "deleter_id"
    t.datetime "delete_at"
    t.boolean  "delete_flag",    default: false
    t.integer  "author_id"
    t.integer  "regenerator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "automations", ["name"], name: "index_automations_on_name", unique: true

  create_table "combos", force: true do |t|
    t.integer  "sort"
    t.integer  "part_id"
    t.integer  "sub_part_id"
    t.boolean  "delete_flag",    default: false
    t.integer  "author_id"
    t.integer  "regenerator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameters", force: true do |t|
    t.integer  "part_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "delete_flag"
    t.integer  "author_id"
    t.integer  "regenerator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partclasses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.integer  "company_id"
    t.integer  "property_id"
    t.string   "no"
    t.string   "name"
    t.integer  "partclass_id"
    t.integer  "type_id"
    t.integer  "classify_id"
    t.string   "description"
    t.text     "content"
    t.integer  "table_row_num"
    t.integer  "table_column_num"
    t.integer  "table_line_type1"
    t.integer  "table_line_type2"
    t.integer  "table_line_color"
    t.datetime "delete_at"
    t.integer  "deleter_id"
    t.boolean  "delete_flag",      default: false
    t.integer  "author_id"
    t.integer  "regenerator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["company_id", "name"], name: "index_parts_on_company_id_and_name", unique: true

  create_table "properties", force: true do |t|
    t.integer  "company_id"
    t.string   "code"
    t.string   "name"
    t.integer  "propertyID"
    t.boolean  "delete_flag"
    t.integer  "author_id"
    t.integer  "regenerator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
