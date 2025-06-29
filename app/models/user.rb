class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self,
         omniauth_providers: [:google_oauth2]

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
  has_many :favorite_decks, dependent: :destroy
  has_many :viewed_decks, dependent: :destroy


  def self.from_google(u)
    # Can we add name from Google?

    user = User.find_by(email: u[:email], oauth_uid: u[:oauth_uid], oauth_provider: 'google')

    return user if user.present? && user.confirmed_at.present?

    create_with(oauth_uid: u[:oauth_uid], oauth_provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email], confirmed_at: Time.now)
  end
end
