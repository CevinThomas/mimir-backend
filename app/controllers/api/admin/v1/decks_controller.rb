# frozen_string_literal: true

module Api
  module Admin
    module V1
      class DecksController < ApplicationController
        before_action :authenticate_user!
        before_action :validate_account
        def index
          decks = Deck.for_account(current_user)

          decks = decks.active if params[:status] == "active"
          decks = decks.inactive if params[:status] == "inactive"

          render json: decks
        end

        def show
          deck = Deck.find(params[:id])
          render json: deck
        end

        def create
          deck = Deck.new(deck_params.except(:cards))
          deck.account = current_user.account
          deck.save!

          if deck_params[:cards]
            deck_params[:cards].each do |card_param|
              card = deck.cards.build(card_param.except(:choices))
              card.deck = deck
              card.deck_id = deck.id
              card.choices = card_param[:choices]
            end
          end

          deck.save!
          render json: deck
        end

        def update
          deck = Deck.for_account(current_user).find(deck_id_params[:id])

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

          deck = Deck.for_account(current_user).find(params[:id])
          deck.active = false
          deck.save!
          render json: deck
        end

        private

        def validate_account
          render json: { message: "You have no account" }, head: :bad_request if current_user.account.blank?
        end

        def deck_params
          params.require(:deck).permit(:name, :active, :description, :cards => [:id, :name, :title, :description,
                                                                                :image,
                                                                         :choices =>
          [:name, :correct]])
        end

        def deck_id_params
          params.permit(:id)
        end
      end
    end
  end
end
