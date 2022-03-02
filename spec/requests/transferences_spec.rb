require 'rails_helper'

RSpec.describe 'Transferences', type: :request do
  let(:user) { create(:user) }

  describe 'POST /transferences' do
    let!(:sender) { create(:account) }
    let!(:receiver) { create(:account) }
    let!(:params) do
      { amount: 100, sender_id: sender.id,
        receiver_id: receiver.id, user_id: user.id }
    end
    let!(:invalid_params) do
      { amount: 100, sender_id: sender.id,
        receiver_id: sender.id, user_id: user.id }
    end
    let(:new_transference) { post transferences_path, params: { transference: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new transference' do
        expect { new_transference }.to change(Transference, :count).by(1)
      end

      it 'has flash notice' do
        new_transference

        expect(flash[:notice]).to eq('Transference successfully created.')
      end

      it 'redirects to transferences index' do
        new_transference

        expect(response).to redirect_to transferences_path
      end
    end

    context 'with invalid data' do
      it 'does not create a new transaction' do
        post transferences_path(format: :json), params: { transference: invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /transferences' do
    context 'when logged in' do
      it 'can successfully access transferences index page' do
        sign_in(user)

        get transferences_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a transferences index page' do
        get transferences_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transferences/new' do
    context 'when logged in' do
      it 'can successfully access new transferences form' do
        sign_in(user)

        get new_transference_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new transference form' do
        get new_transference_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
