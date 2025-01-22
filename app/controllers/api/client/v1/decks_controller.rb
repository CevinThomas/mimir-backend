module Api
  module Client
    module V1
      class DecksController < ApplicationController
        before_action :authenticate_user!
        def index
          render json: { id: Deck.last.id }
        end
      end
    end
  end
end
