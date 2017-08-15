require "bundler/setup"
require "feste"
require "action_mailer"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
