require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  describe "#send_reminder" do
    context "when the user is unsubscribed" do
      it "does not send the email" do
        user = create(:user)
        email = create(
          :email,
          mailer: "ReminderMailer",
          action: "send_reminder"
        )
        subscriber = create(:subscriber, email: user.email)
        create(
          :subscription,
          cancelled: true,
          email: email,
          subscriber: subscriber
        )

        email = ReminderMailer.send_reminder(user)

        expect(email.to).to eq([])
      end
    end

    context "when the user is subscribed" do
      it "has a link to the subscription path" do
        user = create(:user)
        email = create(
          :email,
          mailer: "ReminderMailer",
          action: "send_reminder"
        )
        subscriber = create(:subscriber, email: user.email)
        subscription = create(
          :subscription,
          email: email,
          subscriber: subscriber
        )       

        email = ReminderMailer.send_reminder(user)   
        email_body = Capybara.string(email.body.to_s)
        url = subscription_url(
          token: subscription.token,
          host: ActionMailer::Base.default_url_options[:host]
        )

        expect(email_body).to have_link("Unsubscribe", href: url)
      end
    end
  end
end
