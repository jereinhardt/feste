class UpgradeFeste < ActiveRecord::Migration[5.1]
  def up
    create_table :feste_categories do |t|
      t.string :name, null: false
      t.text :mailers, array: true, default: []
    end

    add_column :feste_subscriptions, :category_id, :string

    Feste::Subscription.in_batches.each_record do |record|
      cat = Feste::Category.find_or_create_by(name: record.category)
      record.update(category_id: cat.id)
    end
  end

  def down
    drop_table :feste_categories
    remove_column :feste_subscriptions, :category_id
  end
end