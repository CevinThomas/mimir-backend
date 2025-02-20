# frozen_string_literal: true

class DeckSessionsController < ApplicationController
  skip_forgery_protection
  respond_to :json
  before_action :authenticate_user!

  # TODO: Make a decksession card serializer

  def index
    # Get all sessions that are active for that User

    deck_sessions = DeckSession.where(user_id: current_user.id)

    render json: deck_sessions, each_serializer: DeckSessionsSerializer
  end

  def create
    deck = Deck.find(params[:deck_id])

    cards = deck.cards

    deck_session = DeckSession.create_deck_session(params[:deck_id], current_user.id)

    render json: { deck_session:, cards: ActiveModelSerializers::SerializableResource.new(cards,
                                                                                          each_serializer:
                                                                                            CardSerializer) }
  end

  def destroy
    # TODO: When we destroy the session, the deck is destroyed
    # TODO: Do we want to destroy the session or just make it inactive?
    deck_session = DeckSession.find(params[:id])
    deck_session.deck_session_excluded_cards.destroy_all
    deck_session.destroy

    render json: { message: 'Deck session deleted' }
  end

  def cards
    cards_to_exclude = DeckSession.find(params[:id]).deck_session_excluded_cards.pluck(:card_id)
    cards = DeckSession.find(params[:id]).deck.cards
    cards_to_include = cards.reject { |card| cards_to_exclude.include?(card.id) }

    render json: { cards: ActiveModelSerializers::SerializableResource.new(cards_to_include.shuffle,
                                                                           each_serializer:
                                                                             CardSerializer) }
  end

  def exclude_card
    deck_session = DeckSession.find(params[:id])
    card_to_exclude = deck_session.deck.cards.find(params[:card_id])

    DeckSessionExcludedCard.create!(deck_session: deck_session, card: card_to_exclude)

    :ok
  end

  def reset_session
    deck_session = DeckSession.find(params[:id])
    deck_session.deck_session_excluded_cards.destroy_all

    render json: deck_session
  end

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
    cards_to_exclude = deck_session.deck_session_excluded_cards.pluck(:card_id)
    cards = deck_session.deck.cards
    cards_to_include = cards.reject { |card| cards_to_exclude.include?(card.id) }

    render json: { deck_session:, cards: ActiveModelSerializers::SerializableResource.new(cards_to_include.shuffle) }
  end
end
