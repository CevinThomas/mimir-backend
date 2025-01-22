# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    name { Faker::Lorem.word }
    title { Faker::Lorem.word }

    after(:create) do |card|
      create_list(:choice, 3, card:)
      create(:choice, card:, correct: true)
    end
  end
end
