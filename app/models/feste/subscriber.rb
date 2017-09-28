module Feste
  class Subscriber < ActiveRecord::Base
    has_many :cancelled_subscriptions
    has_and_belongs_to_many :emails, join_table: :feste_cancelled_subscriptions

    accepts_nested_attributes_for :cancelled_subscriptions

    before_create :generate_token

    private

    def generate_token
      if !self.token
        self.token = SecureRandom.urlsafe_base64
      end
    end
  end
end