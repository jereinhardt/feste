require "rails_helper"

RSpec.feature "User removes a category", js: true do
  scenario "successfully" do
    category = create(:category)

    visit admin_feste.categories_path
    accept_confirm do
      click_on "Delete"
    end

    expect(page).not_to have_text(category.name)
    expect(page).to have_text("Category removed.")
  end
end