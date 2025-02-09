# frozen_string_literal: true

class PromoteRequestsController < ApplicationController
  def index
    unless current_user.role == 'admin'
      return render json: { message: 'You do not have permission to view this request' },
                    status: :unauthorized
    end
    promote_requests = PromoteRequest.where(account_id: current_user.account_id)
    render json: promote_requests
  end

  def approve_promote
    unless current_user.role == 'admin'
      return render json: { message: 'You do not have permission to approve this request' },
                    status: :unauthorized
    end

    promote_request = PromoteRequest.find_by(id: params[:id])
    # TODO: Better than destroy_all
    deck_share_sessions = DeckShareSession.where(deck_id: promote_request.deck_id)
    deck_share_sessions.each(&:destroy)
    deck = promote_request.deck
    deck.account_id = current_user.account_id
    deck.user_id = nil
    deck.save!
    promote_request.status = 'approved'
    promote_request.save!
    :ok
  end
end
