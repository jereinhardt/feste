class <%= migration_class_name %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :feste_subscriptions do |t|
      t.integer :subscriber_id, null: false
      t.string :subscriber_type, null: false
      t.boolean :canceled, null: false, default: false
      t.string :token, null: false
    end

    add_index :feste_subscriptions, :category_id

    create_table :feste_categories do |t|
      t.string :name, null: false
      t.text :mailers, array: true, default: []
  end
end