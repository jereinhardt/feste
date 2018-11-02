class <%= migration_class_name %> < ActiveRecord::Migration<%= migration_version %>
  def up
    create_table :feste_categories do |t|
      t.string :name, null: false
      t.text :mailers, array: true, default: []
    end

    add_column :feste_subscriptions, :category_id, :integer
    add_index :feste_subscriptions, :category_id

    create_category_records

    Feste::Subscription.in_batches.each_record do |record|
      category_name = I18n.t(
        "feste.categories.#{record.read_attribute(:category)}",
        default: record.read_attribute(:category).titleize
      )
      category = Feste::Category.find_by(name: category_name)
      record.update(category_id: category&.id)
    end

    remove_column :feste_subscriptions, :category
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_category_records
    require_mailers
    ActionMailer::Base.descendants.select do |mailer|
      mailer.respond_to?(:action_categories)
    end.each { |mailer| create_category_records_from_mailer(mailer) }
  end

  def require_mailers
    Dir[Rails.root.join("app", "mailers", "**", "*mailer.rb")].each do |file|
      require file
    end
  end

  def create_category_records_from_mailer(mailer)
    if mailer.action_categories[:all]
      category_name = I18n.t(
        "feste.categories.#{mailer.action_categories[:all]}",
        default: mailer.action_categories[:all].to_s.titleize
      )
      category = Feste::Category.find_or_create_by(name: category_name)
      mailer.action_methods.each do |method|
        category.mailers << "#{mailer}##{method}"
      end
      category.save!
    else
      mailer.action_categories.each do |action, category_sym|
        category_name = I18n.t(
          "feste.categories.#{category_sym}",
          default: category_sym.to_s.titleize
        )
        category = Feste::Category.find_or_create_by(name: category_name)
        category.mailers << "#{mailer}##{action}"
        category.save!
      end
    end
  end
end