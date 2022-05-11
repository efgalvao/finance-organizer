require 'rails_helper'

RSpec.describe 'Investments::Treasury::Negotiation', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account) }

  describe 'GET /investments/treasuries/:id/negotiations' do
    context 'when logged in' do
      it 'can successfully access treasuries index page' do
        sign_in(user)

        get investments_treasury_negotiations_path(treasury)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasuries index page' do
        get investments_treasury_negotiations_path(treasury)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /investments/treasuries/:id/negotiations' do
    let(:new_negotiation) do
      post investments_treasury_negotiations_path(treasury), params: { investments_negotiation: valid_params }
    end
    let(:valid_params) { attributes_for(:negotiation).merge(treasury_id: treasury.id) }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new negotiation', :aggregate_failures do
        expect { new_negotiation }.to change(Investments::Treasury::Negotiation, :count).by(1)
        expect(new_negotiation).to be(302)
      end
    end

    context 'with invalid data' do
      let(:invalid_treasury) do
        post investments_treasury_negotiations_path(treasury), params: { investments_negotiation: invalid_params }
      end
      let(:invalid_params) { { amount: 9550, shares: 23, kind: :buy, treasury_id: treasury.id } }

      it 'does not create a new negotiation' do
        invalid_treasury

        expect { invalid_treasury }.not_to change(Investments::Treasury::Negotiation, :count)
      end
    end
  end
end
