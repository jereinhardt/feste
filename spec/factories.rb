FactoryBot.define do
  factory :subscription, class: Feste::Subscription do
    subscriber { create(:user) }
    canceled false
    category "test_action"
  end

  factory :category, class: Feste::Category do
    sequence(:name) { |n| "email-category-#{n}" }
    mailers { [] }
  end
end