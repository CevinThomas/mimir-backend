# frozen_string_literal: true

module Admin
  class CardSerializer < ActiveModel::Serializer
    attributes :name, :choices, :id, :description, :title
  end
end
