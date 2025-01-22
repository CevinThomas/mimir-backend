class Account < ApplicationRecord
  has_many :user
  has_many :decks, dependent: :nullify
end
