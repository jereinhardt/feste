class CreateFesteEmailsTable < ActiveRecord::Migration
  def change
    create_table :feste_emails do |t|
      t.string :mailer, null: false
      t.string :action, null: false
    end
  end
end