# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def user_info
    render json: current_user, serializer: Client::UserSerializer
  end
end
