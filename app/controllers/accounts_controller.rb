# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!
  def show
    account = User.includes(:account).find_by(id: current_user.id).account
    render json: account
  end
end
