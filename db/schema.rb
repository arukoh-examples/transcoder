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

ActiveRecord::Schema.define(:version => 20130225163202) do

  create_table "contents", :force => true do |t|
    t.string   "name"
    t.string   "mime_type"
    t.integer  "size"
    t.string   "link"
    t.string   "bucket"
    t.string   "object_key"
    t.datetime "created_at"
  end

  add_index "contents", ["object_key"], :name => "index_contents_on_object_key", :unique => true

  create_table "transcodes", :force => true do |t|
    t.integer  "content_id"
    t.string   "job_id"
    t.string   "preset_id"
    t.text     "preset_detail"
    t.string   "bucket"
    t.string   "object_key"
    t.string   "thumbnail_key_prefix"
    t.datetime "created_at"
  end

  add_index "transcodes", ["content_id", "job_id"], :name => "index_transcodes_on_content_id_and_job_id"

end
