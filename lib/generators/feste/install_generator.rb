require "rails/generators"
require "rails/migration"
require "active_record"
require "rails/generators/active_record"

module Feste
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.exapnd_path("../templates", __FILE__)

      # Implement the required interface for Rails::Generators::Migration
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime(), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end

      def copy_migration
        migration_template "install.rb", "db/migrate/install_feste.rb", migration_version: migration_version
      end

      def migration_version
        if ActiveRecord::VERSION::MAJOR >= 5
          "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
    end
  end
end

# module Feste
#   module Generators
#     class InstallGenerator < Rails::Generators::Base
#       include Rails::Generators::Migration

#       source_root File.expand_path("../templates", __FILE__)

#       def copy_migrations
#         migration_template "create_feste_emails"
#         migration_template "create_feste_subscribers"
#         migration_template "create_feste_cancelled_subscriptions"
#       end

#       protected

#       def check_and_copy_migration(filename)
#         if self.class.migration_exists?("db/migrate", filename)
#           say_status("skipped", "Migration #{filename}.rb already exists")
#         else
#           migration_template "migrations/#{filename}.rb", "db/migrate/#{filename}.rb"
#         end
#       end
#     end
#   end
# end