require 'rails_helper'

RSpec.describe 'Transaction', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let!(:transaction) { create(:transaction, account: account) }

  describe 'GET /accounts/:account_id/transactions' do
    context 'when logged in' do
      it 'can successfully access transactions index page' do
        sign_in(user)

        get account_transactions_path(account.id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a transactions index page' do
        get account_transactions_path(account.id)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transactions/new' do
    context 'when logged in' do
      it 'can successfully access transactions index page' do
        sign_in(user)

        get new_account_transaction_path(account.id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new transaction page' do
        get new_account_transaction_path(account.id)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /transactions' do
    let!(:account) { create(:account, :with_balance) }
    let(:new_transaction) { post account_transactions_path(account.id), params: { account_transaction: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:transaction) }

      it 'creates a new Stock' do
        expect { new_transaction }.to change(Account::Transaction, :count).by(1)
      end

      it 'has flash notice' do
        new_transaction

        expect(flash[:notice]).to eq('Transaction successfully created.')
      end

      it 'redirects to transactions_path' do
        new_transaction

        expect(response).to redirect_to account_transactions_path(account.id)
      end
    end

    context 'with invalid data' do
      let(:params) { attributes_for(:transaction, title: nil) }

      it 'does not create a new transaction' do
        expect { new_transaction }.to change(Account::Transaction, :count).by(0)
      end
    end
  end

  describe 'GET /transactions/:id/edit' do
    context 'when logged in' do
      it 'can successfully access a transaction edit page' do
        sign_in(user)

        get edit_account_transaction_path(account_id: transaction.account.id,
                                          id: transaction.id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a transaction edit page' do
        get edit_account_transaction_path(account_id: transaction.account.id,
                                          id: transaction.id)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /transactions/:id' do
    let(:put_transaction) do
      put account_transaction_path(account_id: account.id, id: transaction.id), params: {
        account_transaction: params
      }
    end

    context 'with valid data' do
      let(:params) { attributes_for(:transaction, title: 'New Transaction') }

      before { sign_in(user) }

      it 'can successfully update a transaction', :aggregate_failures do
        put_transaction

        transaction.reload

        expect(transaction.title).to eq('New Transaction')
        expect(response).to redirect_to account_transactions_path(account.id)
        expect(response.request.flash[:notice]).to eq 'Transaction successfully updated.'
      end
    end

    context 'with invalid data' do
      let(:params) { attributes_for(:transaction, title: nil) }

      before { sign_in(user) }

      it 'does not update transaction' do
        put_transaction

        transaction.reload

        expect(transaction.title).not_to be_nil
      end
    end

    context 'with unauthenticated request' do
      let(:params) { attributes_for(:transaction) }

      it 'can not update a transaction' do
        put_transaction

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
