class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :correct

  belongs_to :card
end
