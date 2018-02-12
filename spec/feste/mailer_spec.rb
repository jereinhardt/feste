require "spec_helper"

RSpec.describe Feste::Mailer do
  describe ".categorize" do
    it "adds all mailer actions to a category" do
      expect(MainMailer.action_categories[:send_mail]).
        to eq("Marketing Emails")
    end

    it "adds selected mailer actions to a category" do
      class TestMailer < ActionMailer::Base
        include Feste::Mailer

        categorize [:test_action], as: "Marketing Emails"

        def test_action(user)
          mail(to: user.email, from: "support@test.com")
        end

        def ignore_action(user)
          mail(to: user.email, from: "support@test.com")
        end
      end

      expect(TestMailer.action_categories[:test_action]).
        to eq("Marketing Emails")
      expect(TestMailer.action_categories[:ignore_action]).to be nil
    end
  end

  describe "#mail", :stubbed_email do
    context "when the mailer action has been categorized" do
      it "creates a Feste::Processor instance and processes an email" do
        allow(ActiveRecord::Base).
          to receive(:descendants).and_return([TestUser])
        subscription = double(Feste::Subscription, token: nil)

        allow(Feste::Subscription).
          to receive(:find_or_create_by).and_return(subscription)

        user = TestUser.new
        allow(TestUser).to receive(:find_by).and_return(user)

        message = MainMailer.send_mail(user)
        processor = instance_double(Feste::Processor, process: nil)
        allow(Feste::Processor).to receive(:new).and_return(processor)

        message.deliver_now

        expect(Feste::Processor).to have_received(:new)
        expect(processor).to have_received(:process)
      end
    end

    context "when the mailer action has not been categorized" do
      it "does not process the email" do
        allow(ActiveRecord::Base).
          to receive(:descendants).and_return([TestUser])
        subscription = double(Feste::Subscription, token: nil)

        user = TestUser.new
        allow(Feste::Subscription).
          to receive(:find_subscribed_user).and_return(user)
        message = MainMailer.send_less_mail(user)
        allow(Feste::Processor).to receive(:new)

        message.deliver_now

        expect(Feste::Processor).not_to have_received(:new)
      end
    end

    context "when there is no record with the given email address" do
      it "does not process the email" do
        allow(ActiveRecord::Base).
          to receive(:descendants).and_return([TestUser])
        allow(TestUser).to receive(:find_by).and_return(nil)
        message = MainMailer.send_less_mail(TestUser.new)
        allow(Feste::Processor).to receive(:new)

        message.deliver_now

        expect(Feste::Processor).not_to have_received(:new)
      end
    end
  end
end