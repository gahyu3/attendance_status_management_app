FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "user#{n}" }
    sequence(:email)     { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
