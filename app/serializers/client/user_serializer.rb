# frozen_string_literal: true

module Client
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :name, :role
  end
end
