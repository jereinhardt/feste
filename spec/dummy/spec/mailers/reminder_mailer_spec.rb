require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer, categories: true do
  describe "#send_reminder" do
    context "when the user is unsubscribed" do
      it "does not send the email" do
        user = create(:user)
        category = Feste::Category.find_by(name: "Reminder Emails")
        create(
          :subscription,
          canceled: true,
          category: category,
          subscriber: user
        )

        email = ReminderMailer.send_reminder(user).deliver_now

        expect(email).to be nil
      end
    end

    context "when the user is subscribed" do
      it "has a link to the subscription path" do
        user = create(:user)
        category = Feste::Category.find_by(name: "Reminder Emails")
        subscription = create(
          :subscription,
          canceled: false,
          category: category,
          subscriber: user
        )

        email = ReminderMailer.send_reminder(user)   
        email_body = Capybara.string(email.body.to_s)
        url = subscriptions_url(
          token: subscription.token,
          host: ActionMailer::Base.default_url_options[:host]
        )

        expect(email_body).to have_link("Unsubscribe", href: url)
      end
    end
  end
end
