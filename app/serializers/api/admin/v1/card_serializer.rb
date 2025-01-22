# frozen_string_literal: true

module Api
  module Admin
    module V1
      class CardSerializer < ActiveModel::Serializer
        attributes :name, :choices, :id, :description, :title
      end
    end
  end
end

