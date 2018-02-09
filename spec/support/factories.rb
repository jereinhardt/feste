FactoryBot.define do
  factory :subscription, class: Feste::Subscription do
    sequence(:token) { |n| "token-#{n}" }
    cancelled false
    association :subscriber, factory: :subscriber
    association :email, factory: :email
  end

  factory :subscriber, class: Feste::Subscriber do
    email "user@email.com"
    sequence(:token) { |n| "token-#{n}" }
  end

  factory :email, class: Feste::Email do
    mailer "TestMailer"
    action "test_action"
  end
end