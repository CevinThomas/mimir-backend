# frozen_string_literal: true

FactoryBot.define do
  factory :deck_session do
    completed_at { nil }
    started_at { Time.now }
    total_cards { deck.cards.count }

    deck
    user

    after(:create) do |deck_session|
      deck_session.deck.cards.shuffle.each do |card|
        deck_session.deck_session_cards.create(name: card.name, title: card.title, choices: card.choices, deck_session:)
      end

    end
  end
end
