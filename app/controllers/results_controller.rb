# frozen_string_literal: true

class ResultsController < ApplicationController
  before_action :authenticate_user!
  def index
    deck_sessions_for_user = DeckSession.where(user_id: params[:user_Id]).all.pluck(:id)

    results = Result.where(deck_session_id: deck_sessions_for_user)
    render json: results, each_serializer: Api::Client::V1::ResultsSerializer
  end

  def show
    result = Result.find(params[:id])

    render json: result
  end
end
