# frozen_string_literal: true

class DecksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_account?
  def index
    decks = correct_deck_scope

    decks = decks.active if params[:status] == 'active'
    decks = decks.inactive if params[:status] == 'inactive'

    render json: decks
  end

  def show
    deck = correct_deck_scope.find(deck_id_params[:id])
    render json: deck
  end

  def create
    deck = Deck.new(deck_params.except(:cards))
    if @user_is_account
      deck.account = current_user.account
    else
      deck.user = current_user
    end
    deck.save!

    deck_params[:cards]&.each do |card_param|
      card = deck.cards.build(card_param.except(:choices))
      card.deck = deck
      card.deck_id = deck.id
      card.choices = card_param[:choices]
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

  def share
    deck = correct_deck_scope.find_by(id: deck_id_params[:id], user: current_user)

    return render json: { message: 'Deck was not found with that id' }, status: :not_found if deck.blank?

    if deck.share_uuid.blank?
      deck.share_uuid = SecureRandom.uuid
      deck.save!
    end

    render json: { share_uuid: deck.share_uuid }
  end

  def accept_share
    deck = Deck.find_by(share_uuid: params[:share])

    return render json: { message: 'Cannot share the deck with yourself' }, status: :ok if deck.user == current_user

    DeckShareSession.create!(deck: deck, user: current_user, owner_user: deck.user)

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
    params.require(:deck).permit(:name, :active, :description, cards: [:id, :name, :title, :description,
                                                                       :image,
                                                                       { choices: %i[name correct] }])
  end

  def deck_id_params
    params.permit(:id)
  end
end
