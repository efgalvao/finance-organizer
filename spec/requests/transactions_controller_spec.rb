require 'rails_helper'

RSpec.describe Transactions, type: :request do
  let(:user) { create(:user) }

  describe 'GET /transactions/debit' do
    context 'when logged in' do
      it 'can successfully access transactions debit page' do
        sign_in(user)

        get transactions_debit_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access transactions debit page' do
        get transactions_debit_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transactions/credit' do
    context 'when logged in' do
      it 'can successfully access transactions credit page' do
        sign_in(user)

        get transactions_credit_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access transactions credit page' do
        get transactions_credit_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transactions/income' do
    context 'when logged in' do
      it 'can successfully access transactions income page' do
        sign_in(user)

        get transactions_income_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access transactions income page' do
        get transactions_income_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transactions/invoice' do
    context 'when logged in' do
      it 'can successfully access transactions invoice page' do
        sign_in(user)

        get transactions_invoice_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access transactions invoice page' do
        get transactions_invoice_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /transactions' do
    let(:account) { create(:account) }
    let(:category) { create(:category, user: user) }
    let(:new_transaction) { post transactions_path, params: { transaction: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) do
        { title: 'Fake Title', category_id: category.id, account_id: account.id, kind: 'income',
          value: 1, parcels: 1, date: '2023-01-25' }
      end

      it 'creates a new Transaction' do
        expect { new_transaction }.to change(Account::Transaction, :count).by(1)
      end

      it 'has flash notice' do
        new_transaction

        expect(flash[:notice]).to eq('Transaction successfully created.')
      end

      it 'redirects to transactions_path' do
        new_transaction

        expect(response).to redirect_to account_path(account.id)
      end
    end

    context 'with invalid data' do
      let(:params) do
        { title: '', category_id: category.id, account_id: account.id, kind: 'income',
          value: 1, parcels: 1, date: '2023-01-25' }
      end

      it 'does not create a new transaction', :aggregate_failures do
        expect { new_transaction }.to change(Account::Transaction, :count).by(0)
      end

      it 'has flash notice' do
        new_transaction

        expect(flash[:notice]).to eq('Transaction not created.')
      end
    end
  end
end
