# frozen_string_literal: true

class DecksFolder < ApplicationRecord
  self.table_name = "decks_folder"
  belongs_to :deck
  belongs_to :folder
end
