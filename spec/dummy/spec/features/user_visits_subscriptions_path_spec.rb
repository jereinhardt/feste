require "rails_helper"

RSpec.feature "user visits subscriptions path" do
  context "when she has a user record" do
    context "when she visit with a token" do
      scenario "and sees all subscribable mailers" do
        user = create(:user)

        create(:subscription, subscriber: user, category: "Outreach Emails")
        create(:subscription, subscriber: user, category: "Marketing Emails")
        subscription = create(:subscription, 
          subscriber: user,
          category: "Reminder Emails",
          canceled: true
        )

        visit subscriptions_path(token: subscription.token)

        outreach_checkbox = find("#subscription-outreach-emails")
        marketing_checkbox = find("#subscription-marketing-emails")
        reminder_checkbox = find("#subscription-reminder-emails")

        expect(page).to have_text("Outreach Emails")
        expect(page).to have_text("Marketing Emails")
        expect(page).to have_text("Reminder Emails")

        
        expect(outreach_checkbox.checked?).to be true
        expect(marketing_checkbox.checked?).to be true
        expect(reminder_checkbox.checked?).to be false
      end
    end
    
    context "when she visit without a token" do
      scenario "and sees all subscribable mailers" do
        user = create(:user)
        inject_session(user_id: user.id)

        visit subscriptions_path

        outreach_checkbox = find("#subscription-outreach-emails")
        marketing_checkbox = find("#subscription-marketing-emails")
        reminder_checkbox = find("#subscription-reminder-emails")  

        expect(page).to have_text("Outreach Emails")
        expect(page).to have_text("Marketing Emails")
        expect(page).to have_text("Reminder Emails")
        expect(outreach_checkbox.checked?).to be true
        expect(marketing_checkbox.checked?).to be true
        expect(reminder_checkbox.checked?).to be true    
      end
    end
  end

  context "when she does not have a user record" do
    scenario "and receives a 404 error" do
    end
  end
end