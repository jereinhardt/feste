require "active_record"

require "feste/version"
require "feste/engine" if defined?(Rails)
require "feste/user"
require "feste/processor"
require "feste/mailer"

module Feste
  mattr_accessor :options

  def self.table_name_prefix
    "feste_"
  end

  self.options = {
    email_source: :email
  }
end
