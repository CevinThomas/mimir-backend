# frozen_string_literal: true

class DeckSerializer < ActiveModel::Serializer
  attributes :name, :description, :id, :active, :cards, :user, :featured, :number_of_cards

  belongs_to :user
  belongs_to :account
  has_many :cards
  has_many :favorite_decks
  has_many :choices, through: :cards

  def user
    object&.user&.id
  end

  def number_of_cards
    object.cards.count
  end
end
