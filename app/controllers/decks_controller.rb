# frozen_string_literal: true

class DecksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_account?
  def index
    decks = Deck.where(user: current_user)

    decks = decks.active if params[:status] == 'active'
    decks = decks.inactive if params[:status] == 'inactive'

    render json: decks
  end

  def show
    # TODO: This is a mess, find a way to search for tierh user or account

    deck = Deck.find_by(id: deck_id_params[:id], user: current_user)

    deck = Deck.find_by(id: deck_id_params[:id], account: current_user.account) if deck.blank?

    deck = DeckShareSession.find_by(deck_id: deck_id_params[:id], user: current_user)&.deck if deck.blank?

    return render json: { message: 'Deck was not found with that id' }, status: :not_found if deck.blank?

    # TODO: Don't return everything about the shared user

    shared_from = (deck.deck_share_sessions.first&.owner_user unless deck.user_id == current_user.id)

    render json: { deck:, shared_from:, promote_request: deck.promote_request }
  end

  def create
    deck = Deck.new(deck_params.except(:cards))
    deck.account = current_user.account if current_user.role == 'admin'
    deck.user = current_user

    deck.save!

    deck_params[:cards]&.each do |card_param|
      card = deck.cards.build(card_param.except(:choices))
      card.deck = deck
      card.name = card_param[:title]
      card.deck_id = deck.id
      card.save!

      card_param[:choices]&.each do |choice_param|
        Choice.create!({
                         card_id: card.id,
                         name: choice_param[:name],
                         title: choice_param[:title],
                         correct: choice_param[:correct]
                       })
      end
    end

    deck.save!
    render json: deck
  end

  def update
    deck = correct_deck_scope.find(deck_id_params[:id])

    ActiveRecord::Base.transaction do
      deck.name = deck_params[:name]
      deck.description = deck_params[:description]
      deck.active = deck_params[:active]

      if deck_params[:cards].present?
        deck_params[:cards].each do |card_param|
          if card_param.present? && card_param[:id].blank?
            card = deck.cards.build(card_param.except[:id])
            card.deck = deck
            card.deck_id = deck.id
          else
            card = deck.cards.find(card_param[:id])
          end

          if card.blank?
            card = deck.cards.build(card_param.except[:id])
            card.deck = deck
            card.deck_id = deck.id
          else
            card.assign_attributes({
                                     name: card_param[:name],
                                     description: card_param[:description],
                                     choices: card_param[:choices],
                                     title: card_param[:title]
                                   })
            card.save!
          end
        end
      end

      deck.save!
    end

    render json: deck
  end

  def destroy
    deck = correct_deck_scope.find(deck_id_params[:id])
    deck.active = false
    deck.save!
    render json: deck
  end

  def account_decks
    decks = Deck.where(account: current_user.account).active

    render json: decks
  end

  def share_with
    deck = Deck.find_by(id: deck_id_params[:id], user: current_user)

    deck = Deck.find_by(id: deck_id_params[:id], account: current_user.account) if deck.nil?

    shared_with = deck.deck_share_sessions.map(&:user)

    users = User.where(account_id: current_user.account_id)

    eligible_users = users.select { |user| user.id != current_user.id && !shared_with.include?(user) }

    render json: eligible_users, each_serializer: UserSerializer
  end

  def shared
    deck_share_sessions = DeckShareSession.where(user: current_user, active: true)
    decks = deck_share_sessions.map(&:deck)
    render json: decks
  end

  def shared_session
    # TODO: gotta be a better way than doing this ugly destroy_all stuff
    deck_share_session = DeckShareSession.find_by(user: current_user, deck_id: deck_id_params[:id], active: true)
    deck_sessions = DeckSession.where(deck: deck_share_session.deck, user: current_user)
    deck_session_excluded_cards = deck_sessions.map(&:deck_session_excluded_cards).flatten
    deck_session_excluded_cards.each(&:destroy)
    deck_sessions.destroy_all
    deck_share_session.destroy
    :ok
  end

  def share
    deck = Deck.find_by(id: params[:id], user: current_user)
    users_to_share_deck_with = User.where(account_id: current_user.account_id, id: params[:user_ids])

    users_to_share_deck_with.each do |user|
      DeckShareSession.create!(deck: deck, user: user, owner_user: current_user)
    end

    :ok

    # deck = correct_deck_scope.find_by(id: deck_id_params[:id], user: current_user)

    # return render json: { message: 'Deck was not found with that id' }, status: :not_found if deck.blank?

    # if deck.share_uuid.blank?
    #  deck.share_uuid = SecureRandom.uuid
    #  deck.save!
    # end

    # render json: { share_uuid: deck.share_uuid }
  end

  def accept_share
    deck = Deck.find_by(share_uuid: params[:share])

    return render json: { message: 'Cannot share the deck with yourself' }, status: :ok if deck.user == current_user

    DeckShareSession.create!(deck: deck, user: current_user, owner_user: deck.user)

    render json: deck
  end

  def request_promote
    deck = Deck.find_by(id: deck_id_params[:id], user: current_user)
    PromoteRequest.create!(deck: deck, user: current_user, account: current_user.account)
    render json: deck
  end

  private

  def user_is_account?
    @user_is_account ||= current_user.account.present?
  end

  def correct_deck_scope
    return Deck.for_account(current_user) if @user_is_account

    Deck.for_user(current_user)
  end

  def deck_params
    params.require(:deck).permit(:name, :active, :description,
                                 cards: [:name, :title, :description, :image, :explanation, { choices: %i[name correct
                                                                                                          title] }])
  end

  def deck_id_params
    params.permit(:id)
  end
end
