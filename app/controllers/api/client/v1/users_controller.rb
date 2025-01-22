# frozen_string_literal: true

module Api
  module Client
    module V1
      class UsersController < ApplicationController
        before_action :authenticate_user!
        def index
          render json: { status: :ok, users: User.all }
        end

        def create
          user = User.new(user_params)
          if user.save
            render json: { status: :ok, user: }, status: :created
          else
            render json: { status: 422, message: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def health
          render json: { status: :ok, message: 'din mamma' }
        end

        private

        def user_params
          params.permit(:email, :password)
        end
      end
    end
  end
end
