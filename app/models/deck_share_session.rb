# frozen_string_literal: true

class DeckShareSession < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  belongs_to :owner_user, class_name: 'User'

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
