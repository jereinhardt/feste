require "rails/all"
require "factory_bot"
require "factory_bot_rails"

require File.expand_path("../dummy/config/environment.rb", __FILE__)

require "rspec/rails"
require "shoulda/matchers"

ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Schema.verbose = false
load "dummy/db/schema.rb"

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Rails.application.routes.url_helpers
  config.include Feste::Engine.routes.url_helpers
  config.before(:each, type: :mailer) do
    ActionMailer::Base.default_url_options[:host] = "localhost:3000"
  end
end

Capybara.javascript_driver = :webkit
Capybara.default_max_wait_time = 6

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

require "spec_helper"