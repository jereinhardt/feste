module Feste
  class Email < ActiveRecord::Base
    has_many :cancelled_subscriptions
    has_and_belongs_to_many(
      :subscribers,
      join_table: :feste_cancelled_subscriptions
    )
  end
end