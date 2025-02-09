# frozen_string_literal: true

class DeckSessionExcludedCard < ApplicationRecord
  belongs_to :deck_session
  belongs_to :card
end
