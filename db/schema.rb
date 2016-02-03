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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140317235538) do

  create_table "assignments", :force => true do |t|
    t.integer "klass_id"
    t.integer "exercise_id"
  end

  create_table "diagrams", :force => true do |t|
    t.string   "diagram_type"
    t.integer  "exercise_solution_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_id"
    t.string   "name"
  end

  create_table "exercise_solutions", :force => true do |t|
    t.integer "group_id"
    t.integer "exercise_id"
  end

  create_table "exercises", :force => true do |t|
    t.string   "title"
    t.string   "wording"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.string   "solution_type"
    t.integer  "diagram_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "klass_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "klasses", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "query_exercise_answers", :force => true do |t|
    t.string   "answer"
    t.integer  "exercise_solution_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "relationship_fields", :force => true do |t|
    t.string   "name"
    t.float    "x"
    t.float    "y"
    t.integer  "relationship_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "composite"
    t.string   "nulls"
    t.string   "multivalued"
    t.string   "derived"
    t.boolean  "primary_key"
  end

  create_table "relationship_sub_fields", :force => true do |t|
    t.string  "name"
    t.integer "relationship_field_id"
    t.float   "x"
    t.float   "y"
    t.boolean "nulls"
    t.boolean "composite"
    t.boolean "multivalued"
    t.boolean "derived"
  end

  create_table "relationships", :force => true do |t|
    t.string   "name"
    t.string   "null_allowed"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "data_type"
    t.string   "parent_table"
    t.string   "child_table"
    t.string   "ternary_table"
    t.string   "parent_cardinality"
    t.string   "child_cardinality"
    t.string   "ternary_cardinality"
    t.string   "parent_role"
    t.string   "child_role"
    t.integer  "diagram_id"
    t.float    "x"
    t.float    "y"
    t.float    "width"
    t.float    "height"
    t.boolean  "identifying"
  end

  create_table "specializations", :force => true do |t|
    t.float    "x"
    t.float    "y"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "parent_table"
    t.string   "specialized_table_1"
    t.string   "specialized_table_2"
    t.string   "specialized_table_3"
    t.string   "specialized_table_4"
    t.string   "specialized_table_5"
    t.string   "specialized_table_6"
    t.string   "specialized_table_7"
    t.string   "specialized_table_8"
    t.string   "specialized_table_9"
    t.string   "specialized_table_10"
    t.integer  "diagram_id"
  end

  create_table "table_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "primary_key"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "table_id"
    t.boolean  "nulls"
    t.float    "x"
    t.float    "y"
    t.boolean  "composite"
    t.boolean  "multivalued"
    t.boolean  "derived"
    t.boolean  "foreignkey"
    t.string   "data_type"
  end

  create_table "table_sub_fields", :force => true do |t|
    t.string  "name"
    t.integer "table_field_id"
    t.float   "x"
    t.float   "y"
    t.boolean "primary_key"
    t.boolean "foreignkey"
    t.boolean "nulls"
    t.boolean "composite"
    t.boolean "multivalued"
    t.boolean "derived"
    t.string  "data_type"
  end

  create_table "tables", :force => true do |t|
    t.string   "name"
    t.float    "x"
    t.float    "y"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "diagram_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.integer  "group_id"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
