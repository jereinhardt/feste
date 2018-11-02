require "rails_helper"

RSpec.feature "User edits a category" do
  context "successfully" do
    scenario "and sees the success message" do
      category = create(:category, name: "Marketing Emails")
      category_name = "Outreach Mailers"

      visit admin_feste.edit_category_path(category)
      fill_in :category_name, with: category_name
      find("input[value='MarketingMailer#send_offer']").set(true)
      click_on "Submit"

      expect(page).to have_text("Successfully updated #{category_name}")
    end
  end

  context "with invalid inputs" do
    scenario "and sees the error messages" do
      category = create(:category, name: "Marketing Emails")

      visit admin_feste.edit_category_path(category)
      fill_in :category_name, with: ""
      click_on "Submit"

      expect(page).to have_text("There was in issue updating this category.")
      expect(page).to have_text("name: can't be blank") 
    end
  end
end