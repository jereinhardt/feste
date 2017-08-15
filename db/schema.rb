ActiveRecord::Schema.define(version: 20170809170256) do
  create_table "feste_subscribers", force: :cascade do |t|
    t.string  "email",     null: false
    t.boolean "cancelled", null: false, default: true
  end

  create_table "feste_emails", force: :cascade do |t|
    t.string "mailer", null: false
    t.string "action", null: false
  end

  create_table "feste_cancelled_subscriptions" do |t|
    t.integer "subscriber_id", null: false
    t.integer "email_id",      null: false
    t.boolean "cancelled",     null: false, default: false
    t.string  "token",         null: false
    t.index ["subscriber_id"], name: "index_feste_cancelled_subscriptions_on_subscriber_id", using: :btree
    t.index ["email_id"], name: "index_feste_cancelled_subscriptions_on_email_id", using: :btree
  end
end