ENV["RAILS_ENV"] ||= "test"

require "byebug"
require "feste"
Dir[File.expand_path("/Users/jereinhardt/Documents/feste/app/models/**/*.rb", __FILE__)].sort.each { |file| require file }
require "action_mailer"
require "factory_bot" unless defined?(FactoryBot)
require "factories"


RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |file| require file }
Dir[File.expand_path("../../app/models/**/*.rb", __FILE__)].sort.each { |file| require file }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each, :stubbed_email) do
    mail_message = Mail.new do
      to ["test@email.com"]
      from "test@test.com"
      subject "test"
      body "this"
    end
    allow_any_instance_of(ActionMailer::Base).
      to(receive(:mail)).
      and_return(mail_message)
  end

  config.mock_with :rspec
  config.order = "random"
end