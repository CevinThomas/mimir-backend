# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :deck
  has_many :choices, dependent: :destroy

  validates :deck_id, presence: true
end
