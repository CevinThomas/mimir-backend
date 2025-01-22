class Api::Client::V1::DeckSessionCardSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :image, :choices, :answered_choice, :answered, :correct
end
