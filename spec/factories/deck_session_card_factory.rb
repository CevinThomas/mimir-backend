# frozen_string_literal: true

FactoryBot.define do
  factory :deck_session_card do
    name
    title
    answered { false }
    choices { card.choices }

    deck_session
  end
end