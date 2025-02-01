# frozen_string_literal: true

module Admin
  class DeckSerializer < ActiveModel::Serializer
    attributes :name, :description, :id, :active

    has_many :cards
  end
end
