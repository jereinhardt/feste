class <%= migration_class_name %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :feste_cancelled_subscriptions do |t|
      t.integer :subscriber_id, null: false
      t.integer :email_id, null: false
      t.boolean :cancelled, null: false, default: false
      t.string :token, null: false
    end

    create_table :feste_emails do |t|
      t.string :mailer, null: false
      t.string :action, null: false
    end

    create_table :feste_subscribers do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.boolean :cancelled, null: false, default: false
    end

    add_index :feste_cancelled_subscriptions, :subscriber_id
    add_index :feste_cancelled_subscriptions, :email_id
  end
end