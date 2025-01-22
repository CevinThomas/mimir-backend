class Api::Client::V1::CardSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :image, :choices
end
