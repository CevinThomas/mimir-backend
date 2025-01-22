# frozen_string_literal: true

module Api
  module Client
    module V1
      class SessionsController < ApplicationController
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        def new
          user = User.find_by!(email: params[:email])
          if user&.authenticate(params[:password])
            session[:current_user_id] = user.id
            render json: { status: :ok, user: }
          else
            render json: { status: 401, message: 'Unauthorized' }
          end
        end

        def not_found
          render json: { status: 404, message: 'User not found with email' }, status: :not_found
        end

        def show; end

        def destroy
          session[:user_id] = nil
        end

        private

        def user_params
          params.require(:user).permit(:email, :password)
        end
      end
    end
  end
end
