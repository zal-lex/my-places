# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    association :author, factory: :user
    title { "New place #{rand(999)}" }
    description { "Description of new place #{rand(999)}" }
    latitude { rand(-90..90) }
    longitude { rand(-180..180) }
  end
end
