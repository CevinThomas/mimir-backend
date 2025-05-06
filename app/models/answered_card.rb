# frozen_string_literal: true

class AnsweredCard < ApplicationRecord
  belongs_to :deck_session
  belongs_to :card
  belongs_to :choice
end
