# frozen_string_literal: true

class ViewedDeck < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  belongs_to :account
end
