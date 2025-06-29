# frozen_string_literal: true

class DeckSessionsController < ApplicationController
  skip_forgery_protection
  respond_to :json
  before_action :authenticate_user!

  # TODO: Make a decksession card serializer

  def index
    # Get all sessions that are active for that User

    all_deck_sessions = DeckSession.where(user_id: current_user.id)

    ongoing_sessions = all_deck_sessions.where(completed: false)
    completed_sessions = all_deck_sessions.where(completed: true)

    expired_decks = all_deck_sessions.select do |deck_session|
      deck_session.deck.expired_at.present? && deck_session.deck.expired_at > 2.week.ago && deck_session.deck.user !=
        current_user
    end

    render json: {
      ongoing: serialize_resource(ongoing_sessions, DeckSessionSerializer),
      completed: serialize_resource(completed_sessions, DeckSessionSerializer),
      expired_decks: serialize_resource(expired_decks.compact, DeckSessionSerializer)
    }
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

  def copy
    deck_session = DeckSession.find_by(id: params[:id])
    deck = deck_session.deck

    return render json: { message: 'Deck was not found with that id' }, status: :not_found if deck.blank?

    new_deck = deck.dup

    new_deck.user = current_user
    new_deck.expired_at = nil
    new_deck.active = false
    new_deck.featured = false
    new_deck.save!

    deck.cards.each do |card|
      new_card = card.dup
      new_card.deck = new_deck
      new_card.save!
      card.choices.each do |choice|
        new_choice = choice.dup
        new_choice.card = new_card
        new_choice.save!
      end
    end

    default_folder = Account.includes(:folders).where(id: current_user.account.id).last.folders.find_by(name:
                                                                                                          'Uncategorized')
    DecksFolder.create!(deck: new_deck, folder_id: default_folder.id,
                        account_id: current_user.account.id)

    deck_session.deck_session_excluded_cards.destroy_all
    deck_session.destroy

    render json: :ok
  end

  def cards
    deck_session = DeckSession.includes(:deck_session_excluded_cards, deck: :cards).find(params[:id])
    cards_to_exclude = deck_session.deck_session_excluded_cards.pluck(:card_id)
    cards = deck_session.deck.cards
    cards_to_include = cards.reject { |card| cards_to_exclude.include?(card.id) }

    shuffled_cards = cards_to_include.shuffle
    shuffled_cards = shuffled_cards.rotate if shuffled_cards.first.id == deck_session.last_card_id
    deck_session.last_card_id = shuffled_cards.last.id
    deck_session.save

    render json: { cards: ActiveModelSerializers::SerializableResource.new(shuffled_cards,
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
    deck_session = DeckSession.includes(:deck_session_excluded_cards).find(params[:id])
    deck_session.last_card_id = nil
    deck_session.deck_session_excluded_cards.destroy_all

    render json: deck_session
  end

  def answer_question
    card_id = params[:card_id]
    choice_id = params[:choice_id]

    session = DeckSession.includes(:deck_session_excluded_cards, :answered_cards,
                                   deck: :cards).find(params[:id])

    chosen_choice = Choice.find(choice_id)

    answered_card = AnsweredCard.find_by(deck_session_id: session.id, card_id:)

    if answered_card.nil?
      # TODO: Create answered card

      session.answered_cards.create!(card_id:, choice_id:, user_id: current_user.id, answered_at: Time.now, correct:
        chosen_choice.correct)
      return render json: { message: 'Card answered' }
    end

    return render json: { message: 'Card already answered with that choice' } if answered_card.choice_id == choice_id

    answered_card.update(choice_id:, answered_at: Time.now, correct: chosen_choice.correct)
    answered_card.save!
    render json: { message: 'Card answered' }

  end

  def show
    deck_session = DeckSession.includes(:deck_session_excluded_cards, deck: :cards).find(params[:id])
    cards_to_exclude = deck_session.deck_session_excluded_cards.pluck(:card_id)
    cards = deck_session.deck.cards
    cards_to_include = cards.reject { |card| cards_to_exclude.include?(card.id) }

    shuffled_cards = cards_to_include.shuffle
    deck_session.last_card_id = shuffled_cards.last.id
    deck_session.save

    render json: { deck_session:, cards: ActiveModelSerializers::SerializableResource.new(shuffled_cards) }
  end

  def complete
    deck_session = DeckSession.find(params[:id])
    deck_session.update(completed: true)

    render json: { message: 'Deck session marked as completed' }
  end

  def percentage
    deck_session = DeckSession.includes(:deck, :answered_cards).find(params[:id])

    total_cards = deck_session.deck.cards.count

    filtered_answered_cards = deck_session.answered_cards
    correct_cards = filtered_answered_cards.where(correct: true).count

    percentage = total_cards.zero? ? 0 : (correct_cards.to_f / total_cards * 100).round

    render json: { percentage: percentage }
  end

  private

  def serialize_resource(resource, serializer)
    ActiveModelSerializers::SerializableResource.new(resource, each_serializer: serializer)
  end
end
