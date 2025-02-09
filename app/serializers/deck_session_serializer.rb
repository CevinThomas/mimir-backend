class DeckSessionSerializer < ActiveModel::Serializer
  attributes :id, :deck_session_cards

  has_many :deck_session_cards, serializer: DeckSessionCardSerializer

  def cards
    object.deck_session_cards
  end
end
