class CardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :explanation, :choices

  has_many :choices

  def choices
    object.choices.shuffle
  end
end
