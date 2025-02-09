class Account < ApplicationRecord
  has_many :user
  has_many :decks, dependent: :nullify

  has_one :promote_request, required: false
end
