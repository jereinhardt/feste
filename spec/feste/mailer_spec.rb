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

  describe "::InstanceMethods.mail" do
    it "creates a Feste::Processor instance and processes an email" do
      mail_message = Mail.new do
        to "test@email.com"
        from "test@test.com"
        subject "test"
        body "this"
      end
      allow_any_instance_of(ActionMailer::Base).
        to(receive(:mail)).
        and_return(mail_message)
      message = MailerWithWhitelist.whitelist_action("test@email.com")
      processor = instance_double(Feste::Processor, process: nil)
      allow(Feste::Processor).to receive(:new).and_return(processor)

      message.deliver_now

      expect(Feste::Processor).to have_received(:new)
      expect(processor).to have_received(:process)
    end
  end
end