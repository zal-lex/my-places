# frozen_string_literal: true

FactoryBot.define do
  factory :fav_place do
    association :user, factory: :user
    association :likeable, factory: :place
  end
end
