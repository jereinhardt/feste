require "rails_helper"

RSpec.feature "user visits subscriptions path" do
  context "when she has a user record" do
    context "when she visit with a token" do
      scenario "and sees all subscribable mailers" do
        user = create(:user)

        create(:subscription, subscriber: user, category: :outreach_emails)
        create(:subscription, subscriber: user, category: :marketing_emails)
        subscription = create(:subscription, 
          subscriber: user,
          category: :reminder_emails,
          canceled: true
        )

        visit subscriptions_path(token: subscription.token)

        outreach_checkbox = find("#subscription-outreach-emails")
        marketing_checkbox = find("#subscription-marketing-emails")
        reminder_checkbox = find("#subscription-reminder-emails")

        expect(page).to have_text(I18n.t("feste.categories.marketing_emails"))
        expect(page).to have_text(I18n.t("feste.categories.outreach_emails"))
        expect(page).to have_text(I18n.t("feste.categories.reminder_emails"))
        
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

        expect(page).to have_text(I18n.t("feste.categories.marketing_emails"))
        expect(page).to have_text(I18n.t("feste.categories.outreach_emails"))
        expect(page).to have_text(I18n.t("feste.categories.reminder_emails"))
        expect(outreach_checkbox.checked?).to be true
        expect(marketing_checkbox.checked?).to be true
        expect(reminder_checkbox.checked?).to be true    
      end
    end
  end
end