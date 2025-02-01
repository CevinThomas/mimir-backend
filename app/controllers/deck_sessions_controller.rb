# frozen_string_literal: true

class DeckSessionsController < ApplicationController
  skip_forgery_protection
  respond_to :json
  before_action :authenticate_user!

  def index
    # Get all sessions that are active for that User

    deck_sessions = DeckSession.where(user_id: current_user.id).ongoing

    render json: deck_sessions, each_serializer: DeckSessionsSerializer
  end

  def create
    DeckSession.last.destroy if DeckSession.last

    deck_session = DeckSession.create_deck_session(params[:deck_id], current_user.id)

    render json: deck_session
  end

  def destroy; end

  def answer_question
    deck_session = DeckSession.find(params[:deck_session_id])

    card          = deck_session.current_card
    chosen_choice = card.choices.find { |choice| choice['id'] == params[:selected_choice_id].to_i }

    return render json: { message: 'Choice not found' } unless chosen_choice

    card
      .update!(answered: true,
               answered_choice: params[:selected_choice_id], correct: chosen_choice['correct'])

    if deck_session.on_last_question
      deck_session.finish_session
      return render json: { message: 'Session finished' }
    end

    deck_session.move_to_next_card

    render json: deck_session
  end

  def show
    deck_session = DeckSession.find(params[:id])

    render json: deck_session
  end

  private

  def result_params
    params.require(:deck_session_id).permit(:deck_id, :selected_choice_id)
  end
end
