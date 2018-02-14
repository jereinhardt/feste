FactoryBot.define do
  factory :subscription, class: Feste::Subscription do
    subscriber { create(:user) }
    canceled false
    category "test_action"
  end
end