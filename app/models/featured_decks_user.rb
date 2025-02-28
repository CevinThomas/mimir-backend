# frozen_string_literal: true

class FeaturedDecksUser < ApplicationRecord
  belongs_to :user
  belongs_to :deck
end
