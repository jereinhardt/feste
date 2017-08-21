require "bundler/setup"
require "feste"
require "action_mailer"
require "byebug"

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")
require 'active_record'
require 'nulldb_rspec'
include NullDB::RSpec::NullifiedDatabase
NullDB.configure {|ndb| def ndb.project_root;RAILS_ROOT;end}
ActiveRecord::Base.configurations.merge!('test' => { 'adapter' => 'nulldb' })

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |file| require file }

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

  config.before(:each) do
    schema_path = File.join(RAILS_ROOT, 'db/schema.rb')
    NullDB.nullify(:schema => schema_path)
  end

  config.after(:each) do
    NullDB.restore
  end
end
