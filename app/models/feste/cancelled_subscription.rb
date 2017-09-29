module Feste
  class CancelledSubscription < ActiveRecord::Base
    belongs_to :email
    belongs_to :subscriber

    before_create :generate_token

    def self.get_token_for(user, mailer, action)
      subscriber = Feste::Subscriber.find_or_create_by(email: user.email_source)
      email = Feste::Email.find_or_create_by(mailer: mailer, action: action)
      cancellation = find_or_create_by(subscriber: subscriber, email: email)
      cancellation.token
    end

    def decoded_token
      decoded_string = Base64.decode64(token).split("|")
      {
        email: decoded_string[0],
        mailer: decoded_string[1],
        action: decoded_string[2]
      }
    end

    private

    def generate_token
      if !self.token
        self.token = Base64.
          urlsafe_encode64 "#{subscriber.email}|#{email.mailer}|#{email.action}"
      end
    end
  end
end