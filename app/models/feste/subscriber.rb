module Feste
  class Subscriber < ActiveRecord::Base
    has_many :subscriptions
    has_and_belongs_to_many :emails, join_table: :feste_subscriptions

    accepts_nested_attributes_for :subscriptions

    before_create :generate_token

    private

    def generate_token
      if !self.token
        self.token = SecureRandom.urlsafe_base64
      end
    end
  end
end