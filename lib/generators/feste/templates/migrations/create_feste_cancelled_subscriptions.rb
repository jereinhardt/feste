class CreateFesteCancelledSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :feste_cancelled_subscriptions do |t|
      t.integer :subscriber_id, null: false
      t.integer :email_id, null: false
      t.boolean :cancelled, null: false, default: false,
      t.string :token, null: false
    end

    add_index :feste_cancelled_subscriptions, :subscriber_id
    add_index :feste_cancelled_subscriptions, :email_id
  end
end