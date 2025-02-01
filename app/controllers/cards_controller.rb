# frozen_string_literal: true

class CardsController < ApplicationController
  def create
    card = Card.new(card_params)

    if card.save
      render json: card, status: :created
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def update
    card = Card.find(params[:id])

    if card.update(card_params)
      render json: card
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    card = Card.find(params[:id])
    card.destroy
  end

  private

  def card_params
    params.require(:card).permit(:deck_id, :question, :answer)
  end
end
