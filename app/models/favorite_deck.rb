# frozen_string_literal: true

class FavoriteDeck < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  belongs_to :account
end
