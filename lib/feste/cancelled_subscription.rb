require "active_record"
require "base64"

module Feste
  class CancelledSubscription < ActiveRecord::Base
    belongs_to :email
    belongs_to :subscriber

    before_create :generate_token

    private

    def generate_token
      if !token
        token = Base64.urlsafe_encode64 "#{subscriber.email}|#{email.mailer}|#{email.action}"
      end
    end
  end
end