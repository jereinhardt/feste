require "rails_helper"

RSpec.describe Feste::Mailer do
  describe ".categorize" do
    it "adds all mailer actions to a category" do
      expect(MainMailer.action_categories[:send_mail]).
        to eq(:marketing_emails)
    end

    it "adds selected mailer actions to a category" do
      class TestMailer < ActionMailer::Base
        include Feste::Mailer

        categorize [:test_action], as: :marketing_emails

        def test_action(user)
          mail(to: user.email, from: "support@test.com")
        end

        def ignore_action(user)
          mail(to: user.email, from: "support@test.com")
        end
      end

      expect(TestMailer.action_categories[:test_action]).
        to eq(:marketing_emails)
      expect(TestMailer.action_categories[:ignore_action]).to be nil
    end
  end

  describe "#mail" do
    context "when the mailer action has been categorized" do
      context "when the user has unsubscribed" do
        it "returns nil" do
          category = create(:category, mailers: ["MainMailer#send_mail"]) 
          subscription = create(
            :subscription,
            canceled: true,
            category: category
          )

          message = MainMailer.send_mail(subscription.subscriber).deliver_now

          expect(message).to be nil
        end  
      end

      context "when the user is still subscribed" do
        it "sends the email" do
          category = create(:category, mailers: ["MainMailer#send_mail"]) 
          subscription = create(
            :subscription,
            canceled: false,
            category: category
          )

          message = MainMailer.send_mail(subscription.subscriber)

          expect { message.deliver_now }.
            to raise_error(ActionView::MissingTemplate)
        end
      end
    end

    context "when the mailer action has not been categorized" do
      it "sends the email" do
        allow(ActiveRecord::Base).
          to receive(:descendants).and_return([TestUser])
        subscription = double(Feste::Subscription, token: "token")

        user = TestUser.new
        allow(Feste::Subscription).
          to receive(:find_subscribed_user).and_return(user)
        message = MainMailer.send_less_mail(user)

        expect { message.deliver_now }.
          to raise_error(ActionView::MissingTemplate)
      end
    end
  end
end