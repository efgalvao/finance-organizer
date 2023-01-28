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

  describe 'POST /transactions/invoice_payment' do
    let(:account1) { create(:account, balance: 100) }
    let(:account2) { create(:account, balance: 0) }
    let(:pay_invoice) { post transactions_invoice_payment_path, params: { invoice_payment: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) do
        { value: 100, sender_id: account1.id, receiver_id: account2.id, date: '2023-01-25' }
      end

      it 'creates 2 new Transactions' do
        expect { pay_invoice }.to change(Account::Transaction, :count).by(2)
      end

      it 'has flash notice' do
        pay_invoice

        expect(flash[:notice]).to eq('Invoice paid successfully.')
      end

      it 'redirects to user_summary_path' do
        pay_invoice

        expect(response).to redirect_to user_summary_path
      end

      it 'update correctly account balance' do
        pay_invoice

        account1.reload
        account2.reload

        expect(account1.balance).to eq(0)
        expect(account2.balance).to eq(Money.new(10_000))
      end
    end

    context 'with invalid data' do
      let(:params) do
        {}
      end

      it 'does not create a new transaction', :aggregate_failures do
        expect { pay_invoice }.to change(Account::Transaction, :count).by(0)
      end

      it 'has flash notice' do
        pay_invoice

        expect(flash[:notice]).to eq('Invoice not paid.')
      end
    end
  end
end
