require 'rails_helper'

RSpec.describe 'Transferences', type: :request do
  let(:user) { create(:user) }

  describe 'GET /transferences' do
    subject(:index) { get transferences_path }

    context 'when logged in' do
      it 'can successfully access transferences index page' do
        sign_in(user)

        index

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a transferences index page' do
        index

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /transferences' do
    subject(:post_transference) { post transferences_path, params: { transference: params } }

    let!(:sender) { create(:account) }
    let!(:receiver) { create(:account) }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) do
        { amount: 100, sender_id: sender.id,
          receiver_id: receiver.id, user_id: user.id, date: '' }
      end

      it 'creates a new transference' do
        expect { post_transference }.to change(Transference, :count).by(1)
      end

      it 'has flash notice' do
        post_transference

        expect(flash[:notice]).to eq('Transference successfully created.')
      end

      it 'redirects to transferences index' do
        post_transference

        expect(response).to redirect_to transferences_path
      end
    end

    context 'with invalid data' do
      let!(:params) do
        { amount: 100, sender_id: sender.id,
          receiver_id: sender.id, user_id: user.id, date: '' }
      end

      it 'does not create a new transference' do
        post_transference

        expect { post_transference }.not_to change(Transference, :count)
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
