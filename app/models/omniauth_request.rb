# frozen_string_literal: true

class OmniauthRequest < ApplicationRecord
  self.table_name = "omniauth_request"

  validates :provider, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Check if the request is expired
  def expired?
    expires_at <= Time.current
  end

  # Mark the request as expired
  def mark_as_expired!
    update(expires_at: Time.current)
  end
end
