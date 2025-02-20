# frozen_string_literal: true

class CardsController < ApplicationController
  # TODO: Change Admin::CardSerializer to CardSerializer after makeing a decksession card serializer
  def create
    card = Card.create({
                         deck_id: params[:deck_id],
                         title: card_params[:title],
                         explanation: card_params[:explanation]
                       })

    card_params[:choices].each do |choice|
      card.choices.create({
                            title: choice[:title],
                            correct: choice[:correct]
                          })
    end

    if card.save
      render json: card, status: :created, serializer: Admin::CardSerializer
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def update
    card = Deck.includes(cards: :choices).find_by(id: params[:deck_id], user: current_user).cards.find(params[:id])

    card_params[:choices].each do |choice|
      card.choices.find(choice[:id]).update({
                                              title: choice[:title],
                                              correct: choice[:correct]
                                            })
    end

    if card.update(card_params.except(:choices))
      render json: card, serializer: Admin::CardSerializer
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
    params.require(:card).permit(:title, :explanation, :description, choices: %i[title correct id])
  end
end
