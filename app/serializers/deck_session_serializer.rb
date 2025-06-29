class DeckSessionSerializer < ActiveModel::Serializer
  attributes :id, :deck_session_cards, :filtered_answered_cards

  has_many :deck_session_cards, serializer: DeckSessionCardSerializer
  has_many :answered_cards, serializer: AnsweredCardSerializer
  has_many :deck_session_excluded_cards
  belongs_to :deck

  def cards
    object.deck_session_cards
  end

  def deck
    object.deck
  end

  def filtered_answered_cards
    object.answered_cards
  end
end
