# frozen_string_literal: true

class DeckSerializer < ActiveModel::Serializer
  attributes :name, :description, :id, :active

  has_many :cards
end
