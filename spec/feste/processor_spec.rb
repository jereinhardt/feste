require "spec_helper"

RSpec.describe Feste::Processor do
  describe "#process" do
    context "when a user is unsubscribed to the email that is being sent" do
      it "prevents the email from being sent" do
        user = TestUser.new
        message = stubbed_email_to(user.email)

        allow(Feste::Subscription).
          to receive(:find_subscribed_user).and_return(user)
        subscription = double(canceled?: true)
        allow(Feste::Subscription).to receive(:find_by).and_return(subscription)

        Feste::Processor.new(message, MainMailer, :send_mail).process

        expect(message.to).to eq([])
      end
    end

    context "when a user  is subscribed to the email that is being sent" do
      it "does not prevent the email from being sent" do
        user = TestUser.new
        message = stubbed_email_to(user.email)

        allow(Feste::Subscription).
          to receive(:find_subscribed_user).and_return(user)
        subscription = double(canceled?: false)
        allow(Feste::Subscription).to receive(:find_by).and_return(subscription)

        Feste::Processor.new(message, MainMailer, :send_mail).process

        expect(message.to).to eq([user.email])        
      end
    end
  end

  def stubbed_email_to(email)
    Mail.new do
      to email
      from "test@test.com"
      subject "test"
      body "this"
    end
  end
end