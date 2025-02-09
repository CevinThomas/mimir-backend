# frozen_string_literal: true

class PromoteRequest < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  belongs_to :account

  validates :status, presence: true, inclusion: { in: %w[pending approved denied] }
  # TODO: Add promote request messages? Maybe a separate table?
end
