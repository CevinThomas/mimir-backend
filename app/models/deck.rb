# frozen_string_literal: true

class Deck < ApplicationRecord
  # TODO: Validate so either one of these are present
  enum deck_type: { account_deck: 'account', private_deck: 'private' }
  belongs_to :user, optional: true
  belongs_to :account, optional: true

  has_one :promote_request, required: false

  has_many :favorite_decks, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :choices, through: :cards, dependent: :destroy
  has_many :deck_sessions, dependent: :destroy
  has_many :deck_share_sessions, dependent: :destroy
  has_many :decks_folder, dependent: :destroy
  has_many :folders, through: :decks_folder
  has_many :viewed_decks, dependent: :destroy
  has_many :featured_decks_users, dependent: :destroy

  validates :name, presence: true
  validates :deck_type, presence: true, inclusion: { in: deck_types.keys }

  scope :for_user, ->(user) { where(user_id: user.id) }
  scope :for_account, ->(user) { where(account_id: user.account.id) }
  scope :active, -> { where(active: true) }
  scope :new_decks, ->(user) { where('created_at >= ?', user.last_checked_decks) }
  scope :inactive, -> { where(active: false) }
end
