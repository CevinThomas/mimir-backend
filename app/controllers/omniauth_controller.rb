# frozen_string_literal: true
require 'securerandom'

class OmniauthController < ApplicationController
  def create
    omniauth_request = OmniauthRequest.where(email: omniauth_params[:email]).where("expires_at > ?", Time.current).first

    if omniauth_request.nil?
      secure_params = omniauth_params.to_h
      secure_params[:token] = SecureRandom.uuid
      omniauth_request = OmniauthRequest.create!(secure_params)
    end

    render json: {
      omniauth_url: user_google_oauth2_omniauth_authorize_path,
      token: omniauth_request.token
    }
  end

  def omniauth_window
    redirect_to "/users/google_login"
  end

  def poll_success
    email = params[:email]
    token = params[:token]

    # Search for OmniAuthRequest with matching email and token that is not expired
    omniauth_request = OmniauthRequest.where(email: email, token: token)
                                     .where("expires_at > ?", Time.current)
                                     .first

    if omniauth_request.nil?
      render json: { error: 'Invalid or expired authentication request' }, status: :unauthorized
      return
    end

    # Search for a user with the matching email that is confirmed
    user = User.find_by(email: email)

    if user.nil? || user.confirmed_at.nil?
      render json: { error: 'User not found or not confirmed' }, status: :unauthorized
      return
    end

    # Sign in the user with Devise and Devise JWT
    sign_in user, event: :authentication

    jwt = request.env['warden-jwt_auth.token']

    # Return the JWT in the response
    render json: { message: 'User signed in successfully', token: jwt, user: UserSerializer.new(user)
                                                                                           .serializable_hash },
           status: :ok
  end

  def expire
    token = params[:token]

    request = OmniauthRequest.where(token: token).last

    if request.present?
      request.expires_at = Time.now
      request.save!
    end

    render json: { success: true }
  end

  private

  def omniauth_params
    params.permit(:provider, :email, :omniauth, :token)
  end
end
