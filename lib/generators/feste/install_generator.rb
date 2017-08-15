require "rails/generators"

module Feste
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      def copy_migrations
        migration_template "create_feste_emails"
        migration_template "create_feste_subscribers"
        migration_template "create_feste_cancelled_subscriptions"
      end

      protected

      def check_and_copy_migration(filename)
        if self.class.migration_exists?("db/migrate", filename)
          say_status("skipped", "Migration #{filename}.rb already exists")
        else
          migration_template "migrations/#{filename}.rb", "db/migrate/#{filename}.rb"
        end
      end
    end
  end
end