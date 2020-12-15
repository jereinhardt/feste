FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@gmail.com" }
    sequence(:first_name) { |n| "Joe-#{n}"}
    last_name { "Shmo" }
  end
end
