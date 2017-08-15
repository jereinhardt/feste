class CreateFesteEmailsTable < ActiveRecord::Migration
  def change
    create_table :feste_emails do |t|
      t.string :mailer_name, null: false
      t.string :action_name, null: false
    end
  end
end