require 'rails_helper'

RSpec.describe 'Investments::Treasury::Negotiation', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account) }

  describe 'GET /investments/treasuries/:id/negotiations' do
    context 'when logged in' do
      let!(:negotiations) { create_list(:negotiation, 3, treasury: treasury) }

      it 'can successfully access treasuries index page' do
        sign_in(user)

        get treasury_negotiations_path(treasury)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasuries index page' do
        get treasury_negotiations_path(treasury)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /investments/treasuries/:id/negotiations' do
    subject(:post_negotiation) do
      post treasury_negotiations_path(treasury), params: { negotiation: params }
    end

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:negotiation).merge(treasury_id: treasury.id) }

      it 'creates a new negotiation', :aggregate_failures do
        expect { post_negotiation }.to change(Investments::Treasury::Negotiation, :count).by(1)
        expect(post_negotiation).to be(302)
      end
    end
  end
end
