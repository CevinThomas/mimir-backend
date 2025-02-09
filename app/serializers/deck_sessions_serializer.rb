class DeckSessionsSerializer < ActiveModel::Serializer
  attributes :id, :deck

  belongs_to :deck
end
