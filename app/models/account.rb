class Account < ApplicationRecord
  has_many :users
  has_many :decks, dependent: :nullify

  has_many :promote_request
  has_many :favorite_deck
  has_many :folders

  after_create :create_default_folder

  def create_default_folder
    folders.create(name: 'Uncategorized')
  end
end
