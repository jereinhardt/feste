require "active_record"

module Feste
  class Subscriber < ActiveRecord::Base
    has_many :cancelled_subscriptions
    has_and_belongs_to_many :emails, join_table: :feste_cancelled_subscriptions
  end
end