require "rails_helper"

RSpec.feature "user manages email subscriptions", js: true do
  context "when she has a token" do
    scenario "succesfully after confirming her email address" do
      user = create(:user)
      subscription = create(
        :subscription,
        subscriber: user,
        category: "Marketing Emails"
      )

      visit subscriptions_path(token: subscription.token)

      find("#subscription-marketing-emails").set(false)
      find("#subscription-outreach-emails").set(false)
      find("#subscription-reminder-emails").set(false)

      click_on "Submit"

      expect(page).to have_text("Please Confirm Your Email")

      fill_in "email-confirmation-input", with: user.email
      find("#cofirm-submit-button").click

      expect(find("#subscription-marketing-emails").checked?).to be false
      expect(find("#subscription-outreach-emails").checked?).to be false
      expect(find("#subscription-reminder-emails").checked?).to be false
    end

    scenario "and does not confirm her email address" do
      user = create(:user)
      subscription = create(
        :subscription,
        subscriber: user,
        category: "Marketing Emails"
      ) 

      visit subscriptions_path(token: subscription.token)

      click_on "Submit"

      find("#cofirm-submit-button").click

      expect(page).to have_text("Please enter a valid email address")
    end
  end

  context "when she has no token" do
    scenario "succesfully without having to confirm her email address" do
    end
  end
end

# user = User.create(first_name: "jos", last_name: "re", email: "t@t.com")
# Feste::Subscription.create(subscriber: user, category: "Marketing Emails")