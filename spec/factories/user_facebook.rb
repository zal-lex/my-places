# frozen_string_literal: true

FactoryBot.define do
  factory :user_facebook, class: 'User' do
    name { 'Gaius' }
    username { 'Baltar' }
    email { 'test@example.com' }
    sex { 3 }
    age { 1 }
    provider { 'facebook' }
    uid { '123545' }
    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end
