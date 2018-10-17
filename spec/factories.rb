FactoryBot.define do
  factory :subscription, class: Feste::Subscription do
    subscriber { create(:user) }
    category { create(:category) }
    canceled false
  end

  factory :category, class: Feste::Category do
    sequence(:name) { |n| "email-category-#{n}" }
    mailers { [] }
  end
end