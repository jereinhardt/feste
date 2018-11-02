require "rails_helper"

RSpec.feature "User views categories" do
  context "when no categories exist" do
    scenario "and sees the null state message" do
      visit admin_feste.categories_path

      expect(page).to have_text("Looks like you don't have any categories yet")
    end
  end

  context "when there are categories" do
    scenario "and sees available catories" do
      category = create(:category)

      visit admin_feste.categories_path

      expect(page).to have_text(category.name)
    end
  end
end