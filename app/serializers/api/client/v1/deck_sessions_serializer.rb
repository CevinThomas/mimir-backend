module Api
  module Client
    module V1
      class DeckSessionsSerializer < ActiveModel::Serializer
        attributes :id, :completed_at, :started_at, :total_cards, :current_card_index, :created_at, :deck

        belongs_to :deck
      end
    end
  end
end
