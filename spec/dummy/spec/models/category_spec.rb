require "rails_helper"

RSpec.describe Feste::Category, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:subscriptions) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe ".with_mailers" do
    it "only returns categories with assigned mailers" do
      expected_category = create(:category, mailers: ["Mailer#action"])
      extra_category = create(:category)

      results = Feste::Category.with_mailers

      expect(results).to include(expected_category)
      expect(results).not_to include(extra_category)
    end
  end

  describe ".find_by_mailer" do
    it "returns the category that includes the given mailer" do
      mailer = "Mailer#action"
      category = create(:category, mailers: [mailer])

      result = Feste::Category.find_by_mailer(mailer)

      expect(result).to eq(category)
    end
  end
end