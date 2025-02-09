# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def create
    user = User.create(user_params)
    render json: user
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: user
  end

  def reset_password
    user = User.find(params[:id])

    user.reset_password(params[:password], params[:password_confirmation])
    render json: user
  end

  def send_reset_password_instructions
    user = User.find_by(email: params[:email])
    user.send_reset_password_instructions
    render json: user
  end

  def for_current_account
    users = User.where(account_id: current_user.account_id)

    except_current_user = users.reject { |user| user.id == current_user.id }

    render json: except_current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
