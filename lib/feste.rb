require "feste/version"
require "feste/engine"
require "feste/email"
require "feste/user"
require "feste/subscriber"
require "feste/cancelled_subscription"
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
