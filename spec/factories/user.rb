# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "User_#{rand(999)}" }
    username { "Username_#{rand(999)}" }
    sequence(:email) { |n| "me_user_#{n}@example.com" }
    sex { rand(1..3) }
    age { rand(1..200) }
    is_admin { 'false' }
    confirmed_at { DateTime.now }
    confirmation_token { "dfsdfdsf#{rand(999)}" }
    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end
