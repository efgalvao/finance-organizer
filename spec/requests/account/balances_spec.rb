require 'rails_helper'

RSpec.describe Account::Balance, type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let!(:balance) { create(:balance, account: account) }

  describe 'GET /accounts/:account_id/balances/new' do
    context 'when logged in' do
      it 'can successfully access a new balance page' do
        sign_in(user)

        get new_account_balance_path(account)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new balance page' do
        get new_account_balance_path(account)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /accounts/:account_id/balances' do
    subject(:post_balance) { post account_balances_path(account), params: { balance: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:balance, account_id: account.id) }

      it 'creates a new Balance' do
        expect { post_balance }.to change(described_class, :count).by(1)
      end

      it 'has flash notice' do
        post_balance

        expect(flash[:notice]).to eq('Balance successfully created.')
      end

      it 'redirects to balances_path' do
        post_balance

        expect(response).to redirect_to account_path(account)
      end
    end

    context 'with invalid data' do
      let!(:params) { attributes_for(:balance, account_id: nil) }

      it 'does not create a new balance' do
        post_balance

        expect { post_balance }.to change(described_class, :count).by(0)
      end
    end
  end

  describe 'GET /accounts/:account_id/balances' do
    subject(:balances_index) { get account_balances_path(account) }

    context 'when logged in' do
      it 'can successfully access a new balance page' do
        sign_in(user)

        balances_index

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new balance page' do
        balances_index

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
