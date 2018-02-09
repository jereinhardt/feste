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

ActiveRecord::Schema.define(version: 20180209191151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feste_emails", force: :cascade do |t|
    t.string "mailer", null: false
    t.string "action", null: false
  end

  create_table "feste_subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.boolean "cancelled", default: false, null: false
  end

  create_table "feste_subscriptions", force: :cascade do |t|
    t.integer "subscriber_id", null: false
    t.integer "email_id", null: false
    t.boolean "cancelled", default: false, null: false
    t.string "token", null: false
    t.index ["email_id"], name: "index_feste_subscriptions_on_email_id"
    t.index ["subscriber_id"], name: "index_feste_subscriptions_on_subscriber_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
