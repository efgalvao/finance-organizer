require 'rails_helper'

RSpec.describe 'Investments::Treasury::Position', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account) }

  describe 'GET /investments/treasuries/:id/positions/new' do
    context 'when logged in' do
      it 'can successfully access treasuries index page' do
        sign_in(user)

        get new_treasury_position_path(treasury)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasuries index page' do
        get new_treasury_position_path(treasury)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /investments/treasuries/:id/positions' do
    subject(:post_position) do
      post treasury_positions_path(treasury), params: { position: params }
    end

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:position).merge(treasury_id: treasury.id) }

      it 'creates a new position', :aggregate_failures do
        expect { post_position }.to change(Investments::Treasury::Position, :count).by(1)
        expect(post_position).to be(302)
      end

      it 'has flash notice' do
        post_position

        expect(flash[:notice]).to eq('Position successfully created.')
      end
    end

    context 'with invalid data' do
      let(:params) { { treasury_id: treasury.id } }

      it 'does not create a new position' do
        allow(Investments::Treasury::Position).to receive(:create!).and_raise(StandardError)

        post_position

        expect { post_position }.not_to change(Investments::Treasury::Position, :count)
      end

      it 'has flash notice' do
        allow(Investments::Treasury::Position).to receive(:create!).and_raise(StandardError)

        post_position

        expect(flash[:notice]).to eq('Position not created.')
      end
    end
  end
end
