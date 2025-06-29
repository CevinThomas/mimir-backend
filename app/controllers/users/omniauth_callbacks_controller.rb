# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(from_google_params)

    if user.present?
      sign_in user, event: :authentication
      redirect_to logged_in_path
    else
      redirect_to login_failed_path
    end
  end

  def from_google_params
    @from_google_params ||= {
      oauth_uid: auth.uid,
      email: auth.info.email
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def logged_in
    # This page is shown after successful OAuth login
    # The user can now return to the mobile app
  end

  def login_failed
    # This page is shown after unsuccessful OAuth login
    # The user is informed that login was unsuccessful
  end
end
