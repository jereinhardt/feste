require "rails_helper"

RSpec.feature "User creates a category" do
  context "successfully" do
    scenario "and sees the success message" do
      category_name = "Marketing Emails"

      visit admin_feste.new_category_path
      fill_in :category_name, with: category_name
      find("input[value='MarketingMailer#send_offer']").set(true)
      click_on "Submit"

      expect(page).to have_text("Successfully created #{category_name}")
    end
  end

  context "with errors" do
    scenario "and sees the error message" do
      visit admin_feste.new_category_path
      click_on "Submit"

      expect(page).to have_text("There was an issue creating this category.")
      expect(page).to have_text("name: can't be blank")
    end
  end
end