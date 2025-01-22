# frozen_string_literal: true
module Api
  module Admin
    module V1
      class DeckSerializer < ActiveModel::Serializer
        attributes :name, :description, :id, :active

        has_many :cards
      end
    end
  end
end

