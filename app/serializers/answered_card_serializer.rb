class AnsweredCardSerializer < ActiveModel::Serializer
  attributes :card, :choice, :correct
end
