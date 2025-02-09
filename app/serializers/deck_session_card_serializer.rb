class DeckSessionCardSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :image
end
