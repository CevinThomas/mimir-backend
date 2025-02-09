class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, message: 'Must be a valid email address'
  validates :role, inclusion: { in: [nil, 'admin'] }
  belongs_to :account, optional: true
  belongs_to :department, optional: true
  has_many :decks, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :deck_sessions, dependent: :destroy
  has_many :deck_share_sessions, dependent: :destroy
end
