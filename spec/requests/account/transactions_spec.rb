require 'rails_helper'

RSpec.describe 'Transaction', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let!(:transaction) { create(:transaction, account: account) }

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
    context 'when logged' do
      let(:expected_title) { 'Transaction 1' }

      before { sign_in(user) }

      it 'can successfully update a transaction', :aggregate_failures do
        put transaction_path(transaction), params: {
          transaction: {
            title: expected_title
          }
        }

        transaction.reload
        expect(transaction.title).to eq(expected_title)
        expect(response).to redirect_to transaction_path(transaction)
        expect(response.request.flash[:notice]).to eq 'Transaction successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put transaction_path(transaction, format: :json), params: {
          transaction: {
            title: expected_title
          }
        }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(expected_title.to_json)
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update transaction' do
        put transaction_path(transaction), params: {
          transaction: {
            title: nil
          }
        }

        transaction.reload
        expect(transaction.title).not_to be_nil
      end

      it 'also respond to json', :aggregate_failures do
        put transaction_path(transaction, format: :json), params: { transaction: { title: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a transaction' do
        put transaction_path(transaction), params: {
          transaction: {
            title: 'Transaction 1'
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /transactions' do
    let!(:account) { create(:account) }
    let!(:params) { { title: 'Transaction 1', account_id: account.id } }
    let(:new_transaction) { post transactions_path, params: { transaction: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Stock' do
        expect { new_transaction }.to change(Transaction, :count).by(1)
      end

      it 'has flash notice' do
        new_transaction

        expect(flash[:notice]).to eq('Transaction successfully created.')
      end

      it 'redirects to transactions_path' do
        new_transaction

        expect(response).to redirect_to transaction_path(Transaction.find_by(title: 'Transaction 1'))
      end

      it 'also respond to json', :aggregate_failures do
        post transactions_path(format: :json), params: { transaction: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      it 'does not create a new transaction' do
        post transactions_path(format: :json), params: { transaction: { title: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'also respond to json', :aggregate_failures do
        post transactions_path(format: :json), params: { transaction: { title: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /transactions/:id   ' do
    let!(:new_transaction) { create(:transaction, account: account) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a transaction', :aggregate_failures do
        expect { delete transaction_path(new_transaction) }.to change(Transaction, :count).by(-1)
        expect(flash[:notice]).to eq 'Transaction successfully removed.'
        expect(response).to redirect_to transactions_path
      end

      it 'also respond to json', :aggregate_failures do
        delete transaction_path(new_transaction, format: :json)

        expect(response.status).to eq 204
      end
    end
  end

  describe 'GET /transactions' do
    context 'when logged in' do
      it 'can successfully access transactions index page' do
        sign_in(user)

        get transactions_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a transactions index page' do
        get transactions_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /transactions/new' do
    context 'when logged in' do
      it 'can successfully access transactions index page' do
        sign_in(user)

        get new_transaction_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new transaction page' do
        get new_transaction_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
