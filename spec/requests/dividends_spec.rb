require 'rails_helper'

RSpec.describe 'Dividend', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }
  let(:dividend) { create(:dividend, stock: stock) }

  describe 'GET /investments/stocks/:id/dividends' do
    context 'when logged in' do
      it 'can successfully access dividends index page' do
        sign_in(user)

        get edit_dividend_path(dividend)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a dividends index page' do
        get edit_dividend_path(dividend)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /dividends' do
    let!(:stock) { create(:stock) }
    let!(:params) { { stock_id: stock.id, value: 1_000 } }
    let(:new_dividend) { post dividends_path, params: { dividend: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Dividend' do
        expect { new_dividend }.to change(Dividend, :count).by(1)
      end

      it 'has flash notice' do
        new_dividend

        expect(flash[:notice]).to eq('Dividend successfully created.')
      end

      it 'redirects to dividends_path' do
        new_dividend

        expect(response).to redirect_to dividends_path
      end

      it 'also respond to json', :aggregate_failures do
        post dividends_path(format: :json), params: { dividend: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      let(:invalid_dividend) { build(:dividend) }

      it 'does not create a new dividend' do
        invalid_dividend.stock_id = nil

        expect(invalid_dividend).not_to be_valid
      end
    end
  end
end
