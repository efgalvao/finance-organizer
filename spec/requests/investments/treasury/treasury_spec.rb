require 'rails_helper'

RSpec.describe 'Investments::Treasury::Treasury', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET /investments/treasuries' do
    let(:treasury) { create(:treasury, account: account) }

    context 'when logged in' do
      it 'can successfully access treasuries index page' do
        sign_in(user)

        get treasuries_path

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasuries index page' do
        get treasuries_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /investments/treasuries/:id/' do
    let(:treasury) { create(:treasury, account: account) }

    context 'when logged in' do
      context 'when the treasury exists' do
        it 'can successfully access treasury show page' do
          sign_in(user)

          get treasury_path(treasury)

          expect(response).to have_http_status(:success)
        end
      end

      context 'when the treasury does not exist' do
        xit 'cannot successfully access treasury show page' do
          sign_in(user)

          get treasury_path(treasury)

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access treasury show page' do
        get treasury_path(treasury)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /invetments/treasuries' do
    let(:new_treasury) { post treasuries_path, params: { treasury: params } }
    let(:params) { { account_id: account.id, name: 'New Treasury' } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Treasury', :aggregate_failures do
        expect { new_treasury }.to change(Investments::Treasury::Treasury, :count).by(1)
        expect(new_treasury).to be(302)
      end

      it 'redirects to account_path' do
        new_treasury

        expect(response).to redirect_to account_path(id: account.id)
      end
    end

    context 'with invalid data' do
      let(:invalid_treasury) { post treasuries_path, params: { treasury: invalid_params } }
      let(:invalid_params) { { account_id: account.id, name: nil } }

      it 'does not create a new treasury' do
        invalid_treasury

        expect { invalid_treasury }.not_to change(Investments::Treasury::Treasury, :count)
      end
    end
  end

  describe 'PUT /investments/treasuries/:id' do
    let!(:treasury) { create(:treasury, account_id: account.id) }

    context 'when logged' do
      let(:expected_name) { 'New Name' }
      let(:update_treasury) do
        put treasury_path(treasury), params: {
          treasury: {
            name: expected_name,
            account_id: account.id
          }, id: treasury.id
        }
      end

      before { sign_in(user) }

      it 'can successfully update a treasury' do
        update_treasury

        treasury.reload
        expect(treasury.name).to eq(expected_name)
      end
    end

    context 'with invalid data' do
      let(:invalid_update) do
        put treasury_path(treasury), params: {
          treasury: {
            name: nil,
            account_id: account.id
          }, id: treasury.id
        }
      end

      before { sign_in(user) }

      it 'does not update treasury' do
        invalid_update

        treasury.reload
        expect(treasury.name).not_to eq('')
      end
    end

    context 'with unauthenticated request' do
      let(:update_treasury) do
        put treasury_path(treasury), params: {
          treasury: {
            name: 'New Name',
            account_id: account.id
          }, id: treasury.id
        }
      end

      it 'can not update a treasury' do
        update_treasury

        treasury.reload

        expect(treasury.name).not_to eq('New Name')
      end
    end
  end

  describe 'DELETE /investments/treasuries/:id   ' do
    let!(:treasury) { create(:treasury, account_id: account.id) }
    let(:delete_treasury) do
      delete treasury_path(id: treasury.id)
    end

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a treasury', :aggregate_failures do
        expect { delete_treasury }.to change(Investments::Treasury::Treasury, :count).by(-1)
        expect(flash[:notice]).to eq 'Treasury successfully removed.'
      end
    end
  end
end
