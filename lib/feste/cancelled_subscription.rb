require "active_record"
require "base64"

module Feste
  class CancelledSubscription < ActiveRecord::Base
    belongs_to :email
    belongs_to :subscriber

    before_create :generate_token

    def self.cancellation_exists?(subscriber:,mailer:,action:)
      email = Feste::Email.find_by(mailer: mailer, action: action)
      find_by(subscriber: subscriber, email: email, cancelled: true).present?
    end 

    private

    def generate_token
      if !token
        token = Base64.urlsafe_encode64 "#{subscriber.email}#{email.mailer}#{email.action}"
      end
    end
  end
end