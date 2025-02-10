class Account < ApplicationRecord
  has_many :user
  has_many :decks, dependent: :nullify

  has_many :promote_request
  has_many :favorite_deck
end
