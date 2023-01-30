require 'rails_helper'

RSpec.describe 'Investments::Treasury::Negotiation', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account, current_value: 1) }

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

  describe 'GET /investments/treasuries/:id/negotiations/new' do
    context 'when logged in' do
      it 'can successfully access treasuries index page' do
        sign_in(user)

        get new_treasury_negotiation_path(treasury)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasuries index page' do
        get new_treasury_negotiation_path(treasury)

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
      let(:params) { { date: '2023-01-01', invested: '1.23', kind: 'buy', shares: 1 }.merge(treasury_id: treasury.id) }

      it 'creates a new negotiation' do
        expect { post_negotiation }.to change(Investments::Treasury::Negotiation, :count).by(1)
      end

      it 'has flash notice' do
        post_negotiation

        expect(flash[:notice]).to eq('Negotiation successfully created.')
      end

      it 'updates treasury values', :aggregate_failures do
        expect(treasury.current_value_cents).to eq(100)
        expect(treasury.invested_value_cents).to eq(0)

        post_negotiation

        treasury.reload
        expect(treasury.current_value_cents).to eq(223)
        expect(treasury.invested_value_cents).to eq(123)
      end
    end

    context 'with invalid data' do
      let(:params) { { treasury_id: treasury.id } }

      it 'does not create a new negotiation' do
        allow(Investments::Treasury::Negotiation).to receive(:create!).and_raise(StandardError)

        expect { post_negotiation }.to change(Investments::Treasury::Negotiation, :count).by(0)
      end

      it 'has flash notice' do
        allow(Investments::Treasury::Negotiation).to receive(:create!).and_raise(StandardError)
        post_negotiation

        expect(flash[:notice]).to eq('Negotiation not created.')
      end
    end
  end
end
