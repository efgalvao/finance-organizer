require 'rails_helper'

RSpec.describe 'Balance', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let!(:balance) { create(:balance, account: account) }

  describe 'GET /balances/new' do
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

  describe 'POST /balances' do
    let(:account) { create(:account) }
    let(:params)  { { account_id: account.id, balance: 1000 } }
    let(:new_balance) { post balances_path, params: { balance: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Balance' do
        expect { new_balance }.to change(Balance, :count).by(1)
      end

      it 'has flash notice' do
        new_balance

        expect(flash[:notice]).to eq('Balance was successfully created.')
      end

      it 'redirects to balances_path' do
        new_balance

        expect(response).to redirect_to balances_path
      end

      it 'also respond to json', :aggregate_failures do
        post balances_path(format: :json), params: { balance: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      let(:invalid_balance) { build(:balance, :for_account) }

      it 'does not create a new balance' do
        invalid_balance.account_id = nil

        expect(invalid_balance).not_to be_valid
      end

      it 'also respond to json', :aggregate_failures do
        post balances_path(format: :json), params: { balance: { account_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /account/:id/balances/:id/edit' do
    context 'when logged in' do
      it 'can successfully access an balance edit page' do
        sign_in(user)

        get edit_account_balance_path(balance, account_id: balance.account_id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a balance edit page' do
        get edit_account_balance_path(balance, account_id: balance.account_id)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /balances/:id' do
    context 'when logged' do
      let(:expected_balance) { 1000 }

      before { sign_in(user) }

      it 'can successfully update a balance', :aggregate_failures do
        put balance_path(balance), params: {
          balance: {
            balance: expected_balance
          }
        }

        balance.reload
        expect(balance.balance_cents).to eq(expected_balance * 100)
        expect(response).to redirect_to balance_path(balance)
        expect(response.request.flash[:notice]).to eq 'Balance was successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put balance_path(balance, format: :json), params: {
          balance: {
            balance: expected_balance
          }
        }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(expected_balance.to_json)
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update balance', :aggregate_failures do
        put balance_path(balance, format: :json), params: { balance: { account_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a balance' do
        put balance_path(balance), params: {
          balance: {
            balance: 10_000
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
