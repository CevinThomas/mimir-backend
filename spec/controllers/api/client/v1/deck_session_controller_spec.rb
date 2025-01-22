require 'rails_helper'

RSpec.describe Api::Client::V1::DeckSessionsController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user:) }
    let!(:deck_session) { create(:deck_session, user:, deck:) }
    subject { get :index, params: { user_id: user.id } }

    it 'returns active sessions for the user' do
      subject

      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_body.length).to eq(1)
      expect(parsed_body[0]["id"]).to eq(deck_session.id)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user:) }
    subject { post :create, params: { deck_id: deck.id, user_id: user.id } }

    it 'creates a new deck session' do
      expect { subject }.to change { DeckSession.count }.by(1)
    end

    it 'returns the newly created session' do
      subject

      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_body["id"]).to eq(DeckSession.last.id)
    end
  end

  describe 'POST #answer_question' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user:) }
    let!(:deck_session) { create(:deck_session, user:, deck:) }
    let!(:card) { deck_session.deck_session_cards.first }
    let!(:choice) { card.choices.first }

    subject { post :answer_question, params: { deck_session_id: deck_session["id"], card_id: card["id"],
                                               selected_choice_id: choice["id"] } }

    context 'when user answers last question' do
      it 'finished the session' do
        deck_session.update!(current_card_index: deck_session.total_cards - 1)

        expect { subject }.to change { deck_session.reload.completed_at }.from(nil).to(be_present) .and change {
          Result.count }.by(1)
      end
    end

    context 'when user answers a question' do
      it 'updates the deck_session_card as answered' do
        expect { subject }.to change { card.reload.answered }.from(false).to(true)
      end

      it 'sets the correct answered_choice on the card' do
        expect { subject }.to change { card.reload.answered_choice }.from(nil).to(choice["id"])
      end

      it 'sets the correct flag on the card' do
        expect { subject }.to change { card.reload.correct }.from(nil).to(choice["correct"])
      end

      it 'increments current card index' do
        expect { subject }.to change { deck_session.reload.current_card_index }.by(1)
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user:) }
    let!(:deck_session) { create(:deck_session, user:, deck:) }

    subject { get :show, params: { id: deck_session.id } }

    it 'returns the deck session' do
      subject

      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_body["id"]).to eq(deck_session.id)
    end
  end
end