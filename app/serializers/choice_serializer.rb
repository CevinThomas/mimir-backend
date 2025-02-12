class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :title, :correct

  belongs_to :card
end
