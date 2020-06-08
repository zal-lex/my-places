# frozen_string_literal: true

FactoryBot.define do
  factory :fav_place do
    likeable { nil }
    user { nil }
  end
end
