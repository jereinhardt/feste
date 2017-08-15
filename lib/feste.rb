require "feste/version"
require "feste/email"
require "feste/subscriber"
require "feste/cancelled_subscription"
require "feste/processor"
require "feste/mailer"

module Feste
  def self.table_name_prefix
    "feste_"
  end
end
