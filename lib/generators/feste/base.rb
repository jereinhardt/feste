require "rails/generators"
require "rails/generators/migration"
require "active_record"
require "rails/generators/active_record"

module Feste
  module Generators
    class Base < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [
            Time.now.utc.strftime("%Y%m%d%H%M%S"),
            "%.14d" % next_migration_number
          ].max
        else
          "%.3d" % next_migration_number
        end
      end

      def migration_version
        if ActiveRecord::VERSION::MAJOR >= 5
          "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
    end
  end
end