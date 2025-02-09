class CardSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :image, :explanation, :choices

  has_many :choices
end
