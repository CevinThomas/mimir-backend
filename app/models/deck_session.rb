class DeckSession < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :results, dependent: :destroy
  has_many :deck_session_cards, dependent: :destroy

  before_create :set_started_at

  scope :ongoing, -> { where(completed_at: nil) }

  def self.create_deck_session(deck_id, user_id)
    deck_session = DeckSession.create!(deck_id:, user_id:)
    deck_session.populate_cards
    deck_session
  end

  def populate_cards
    deck.cards.shuffle.each do |card|
      deck_session_cards.create!(
        name: card.name,
        title: card.title,
        description: card.description,
        image: card.image,
        choices: card.choices
      )
    end

    self.total_cards = deck.cards.count
    save
  end

  def shuffle_cards
    deck_session_cards.shuffle
  end

  def move_to_next_card
    self.current_card_index += 1
    save
  end

  def current_card
    deck_session_cards[current_card_index]
  end

  def on_last_question
    current_card_index == total_cards - 1
  end

  def finish_session
    self.completed_at = Time.now
    correct_answers = deck_session_cards.where(correct: true).count
    # MOVE OUT TO RESULT
    Result.create!(deck_session: self, total_cards:, correct_answers:, cards: deck_session_cards)
    save
  end

  private

  def set_started_at
    self.started_at ||= Time.now
  end
end

{
  deck: {
    cards: [
      {},
      {}
    ]
  }
}
