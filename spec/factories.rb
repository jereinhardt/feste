FactoryBot.define do
  factory :subscription, class: Feste::Subscription do
    canceled false
    category "test_action"
  end
end