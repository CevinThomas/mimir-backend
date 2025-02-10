# frozen_string_literal: true

class Deck < ApplicationRecord
  # TODO: Validate so either one of these are present
  belongs_to :user, optional: true
  belongs_to :account, optional: true
  belongs_to :folder, optional: true

  has_one :promote_request, required: false

  has_many :favorite_decks, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :choices, through: :cards, dependent: :destroy
  has_many :deck_sessions, dependent: :destroy
  has_many :deck_share_sessions, dependent: :destroy

  validates :name, presence: true

  scope :for_user, ->(user) { where(user_id: user.id) }
  scope :for_account, ->(user) { where(account_id: user.account.id) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
