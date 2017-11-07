module Feste
  class Email < ActiveRecord::Base
    has_many :subscriptions
    has_and_belongs_to_many(
      :subscribers,
      join_table: :feste_subscriptions
    )
  end
end