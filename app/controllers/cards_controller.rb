# frozen_string_literal: true

class CardsController < ApplicationController
  def create
    card = Card.create({
                         deck_id: params[:deck_id],
                         title: card_params[:title],
                         description: card_params[:description],
                         explanation: card_params[:explanation]
                       })

    if card.save
      render json: card, status: :created
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def update
    card = Deck.includes(:cards).find_by(id: params[:deck_id], user: current_user).cards.find(params[:id])

    if card.update(card_params)
      render json: card
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    card = Deck.includes(:cards).find_by(id: params[:deck_id], user: current_user).cards.find(params[:id])
    card.destroy
    :ok
  end

  private

  def card_params
    params.require(:card).permit(:title, :explanation, :description)
  end
end
