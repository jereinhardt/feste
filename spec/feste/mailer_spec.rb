require "spec_helper"

RSpec.describe Feste::Mailer do
  describe "::ClassMethods.allow_subscriptions" do
    it "adds mailer actions to the whitelist" do
      expect(MailerWithWhitelist.feste_whitelist).to eq([:whitelist_action])
      expect(MailerWithWhitelist.feste_whitelist).not_to include(:other_action)
    end

    it "adds mailer actions to the blacklist" do
      expect(MailerWithBlacklist.feste_blacklist).to eq([:blacklist_action])
      expect(MailerWithBlacklist.feste_blacklist).not_to include(:whitelist_action)
    end
  end

  describe "::InstanceMethods.mail", :stubbed_email do
    it "creates a Feste::Processor instance and processes an email" do
      subscriber = double(Feste::Subscriber)
      email = double(Feste::Email)
      subscription = double(Feste::CancelledSubscription, token: nil)

      allow(Feste::Subscriber).
        to receive(:find_or_create_by).and_return(subscriber)
      allow(Feste::Email).
        to receive(:find_or_create_by).and_return(email)
      allow(Feste::CancelledSubscription).
        to receive(:find_or_create_by).and_return(subscription)

      user = User.new
      message = MailerWithWhitelist.whitelist_action(user)
      processor = instance_double(Feste::Processor, process: nil)
      allow(Feste::Processor).to receive(:new).and_return(processor)

      message.deliver_now

      expect(Feste::Processor).to have_received(:new)
      expect(processor).to have_received(:process)
    end
  end
end