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

ActiveRecord::Schema.define(version: 20171002004546) do

  create_table "competitors", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.string "product_asin"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.decimal "price_low"
    t.decimal "price_high"
    t.string "title"
    t.text "images"
    t.text "features"
    t.integer "number_of_reviews"
    t.integer "best_seller_rank"
    t.integer "inventory"
    t.index ["group_id"], name: "index_competitors_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
