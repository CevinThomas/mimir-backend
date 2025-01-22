module Api
  module Client
    module V1
      class ResultsSerializer < ActiveModel::Serializer
        attributes :id, :correct_answers, :total_cards, :timespan, :created_at, :cards

        belongs_to :deck_session
      end
    end
  end
end
