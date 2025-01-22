module Api
  module Client
    module V1
      class DeckSessionSerializer < ActiveModel::Serializer
        attributes :id, :completed_at, :started_at, :total_cards, :current_card_index, :created_at, :selected_choices,
                   :deck_session_cards

        has_many :deck_session_cards, serializer: DeckSessionCardSerializer

        def cards
          object.deck_session_cards
        end
      end
    end
  end
end
