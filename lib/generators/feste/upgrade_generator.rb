require_relative "base.rb"

module Feste
  module Generators
    class UpgradeGenerator < Feste::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def copy_migration
        migration_template(
          "upgrade.rb",
          "db/migrate/upgrade_feste.rb",
          migration_version: migration_version
        )
      end
    end
  end
end