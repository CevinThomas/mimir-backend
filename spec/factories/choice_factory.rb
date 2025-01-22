# frozen_string_literal: true

FactoryBot.define do
  factory :choice do
    name { Faker::Lorem.word }
    correct { false }
  end
end
