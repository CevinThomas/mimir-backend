class Choice < ApplicationRecord
  belongs_to :card, dependent: :destroy

  has_one :deck, through: :card
end
