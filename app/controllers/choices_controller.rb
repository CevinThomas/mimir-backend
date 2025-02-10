# frozen_string_literal: true

class ChoicesController < ApplicationController
  def create
    choice = Choice.create({
                             card_id: params[:card_id],
                             name: choice_params[:title],
                             title: choice_params[:title],
                             correct: choice_params[:correct]
                           })

    if choice.save
      render json: choice, status: :created
    else
      render json: choice.errors, status: :unprocessable_entity
    end
  end

  def update
    choice = Deck.includes(cards: :choices).find_by(id: params[:deck_id],
                                                    user: current_user).choices.find(params[:id])

    if choice.update(update_choice_params)
      # TODO: Dont udpate name after

      choice.name = update_choice_params[:title]
      choice.save
      render json: choice
    else
      render json: choice.errors, status: :unprocessable_entity
    end
  end

  def destroy
    choice = Deck.includes(cards: :choices).find_by(id: params[:deck_id], user: current_user).choices.find(params[:id])
    choice.destroy!
    :ok
  end

  private

  def choice_params
    params.require(:choice).permit(:title, :correct)
  end

  def update_choice_params
    params.require(:choice).permit(:id, :name, :title, :correct)
  end
end
