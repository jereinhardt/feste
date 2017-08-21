require "active_record"
require "base64"

module Feste
  class CancelledSubscription < ActiveRecord::Base
    belongs_to :email
    belongs_to :subscriber

    before_create :generate_token

    def self.get_token_for(user, mailer, action)
      user = Feste::User.find_or_create_by(email: user.email_source)
      email = Feste::Email.find_or_create_by(mailer: mailer, action: action)
      cancellation = find_or_create_by(user: user, email: email)
      cancellation.token
    end

    private

    def generate_token
      if !token
        token = Base64.urlsafe_encode64 "#{subscriber.email}|#{email.mailer}|#{email.action}"
      end
    end
  end
end