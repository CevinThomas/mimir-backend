class UserSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  attributes :id, :email, :name
end
