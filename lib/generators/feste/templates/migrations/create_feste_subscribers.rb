class CreateFesteSubscribersTable < ActiveRecord::Migration
  def change
    create_table :feste_subscribers do |t|
      t.string :email, null: false
      t.boolean :cancelled, null: false, default: true
    end
  end
end