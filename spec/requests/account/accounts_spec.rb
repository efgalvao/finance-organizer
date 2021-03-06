require 'rails_helper'

RSpec.describe 'Account', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET /accounts' do
    context 'when logged in' do
      it 'can successfully access accounts index page' do
        sign_in(user)

        get accounts_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access an accounts index page' do
        get accounts_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /accounts/new' do
    context 'when logged in' do
      it 'can successfully access new account page' do
        sign_in(user)

        get new_account_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new account page' do
        get new_account_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /accounts' do
    let(:new_account) { post accounts_path, params: { account: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:account) }

      it 'creates a new account' do
        expect { new_account }.to change(Account::Account, :count).by(1)
      end

      it 'has flash notice' do
        new_account

        expect(flash[:notice]).to eq('Account successfully created.')
      end

      it 'redirects to account_path' do
        new_account

        expect(response).to redirect_to account_path(Account::Account.last)
      end
    end

    context 'with invalid data' do
      let(:invalid_account) { build(:account, user: nil) }

      it 'does not create a new account' do
        invalid_account.user = nil

        expect(invalid_account).not_to be_valid
      end
    end
  end

  describe 'GET /accounts/:id/edit' do
    context 'when logged in' do
      it 'can successfully access account edit page' do
        sign_in(user)

        get edit_account_path(account)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a account edit page' do
        get edit_account_path(account)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /accounts/:id' do
    subject(:update_account) { put account_path(account), params: { account: params } }

    context 'when logged' do
      let(:params) { { name: 'Account 1', kind: 'broker' } }

      before { sign_in(user) }

      it { is_expected.to redirect_to account_path(account) }

      it 'can successfully update an account name', :aggregate_failures do
        update_account

        account.reload

        expect(account.name).to eq('Account 1')
        expect(response.request.flash[:notice]).to eq 'Account successfully updated.'
      end

      it 'can not update account balance' do
        update_account

        account.reload

        expect(account.balance_cents).not_to eq(params[:balance_cents])
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update account' do
        put account_path(account), params: {
          account: {
            name: nil
          }
        }

        account.reload
        expect(account.name).not_to be_nil
      end
    end

    context 'with unauthenticated request' do
      it 'cannot update an account' do
        put account_path(account), params: {
          account: {
            name: 'Account 2'
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE /accounts/id:/delete' do
    let!(:new_account) { create(:account, user: user) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes an account', :aggregate_failures do
        expect { delete account_path(new_account) }.to change(Account::Account, :count).by(-1)
        expect(flash[:notice]).to eq 'Account successfully removed.'
        expect(response).to redirect_to accounts_path
      end
    end
  end
end
