# frozen_string_literal: true

module Admin
  class CardSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :image, :explanation, :choices

    has_many :choices
  end
end
