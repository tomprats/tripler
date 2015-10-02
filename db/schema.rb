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

ActiveRecord::Schema.define(version: 20151001232436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedback", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "message",    limit: 255
    t.integer  "user_id"
    t.boolean  "deleted",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "price"
    t.string   "description", limit: 255
    t.string   "image",       limit: 255
    t.boolean  "sold",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "total_price"
    t.integer  "quantity"
    t.integer  "product_id"
    t.integer  "price"
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "image",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "total_price"
    t.string   "description",      limit: 255
    t.string   "charge_token",     limit: 255
    t.integer  "user_id"
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.string   "phone_number",     limit: 255
    t.string   "address1",         limit: 255
    t.string   "city",             limit: 255
    t.string   "state",            limit: 255
    t.string   "zipcode",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipping",         limit: 255
    t.integer  "shipping_total"
    t.boolean  "shipped",                      default: false
    t.datetime "shipped_date"
    t.integer  "shipped_admin_id"
    t.string   "address2"
    t.string   "email"
    t.boolean  "paid",                         default: false
    t.datetime "paid_date"
    t.integer  "discount",                     default: 0
  end

  create_table "packages", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "uuid"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "price"
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "image",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "coming_soon",             default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "email",             limit: 255
    t.string   "password_digest",   limit: 255
    t.string   "phone_number",      limit: 255
    t.string   "address1",          limit: 255
    t.string   "city",              limit: 255
    t.string   "state",             limit: 255
    t.string   "zipcode",           limit: 255
    t.string   "customer_token",    limit: 255
    t.boolean  "admin",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "additional_emails", limit: 255
    t.string   "address2"
  end

end
