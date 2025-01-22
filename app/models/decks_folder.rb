# frozen_string_literal: true

class DecksFolder < ApplicationRecord
  belongs_to :deck
  belongs_to :folder
end
