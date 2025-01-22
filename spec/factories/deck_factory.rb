# frozen_string_literal: true

FactoryBot.define do
  factory :deck do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    after(:create) do |deck|
      create_list(:card, 5, deck:)
    end
  end
end
