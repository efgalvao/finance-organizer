require 'rails_helper'

RSpec.describe 'Dividend', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, :with_balance, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'GET /investments/stocks/:id/dividends' do
    let(:dividend) { create(:dividend, stock: stock) }

    context 'when logged in' do
      it 'can successfully access dividends index page' do
        sign_in(user)

        get stock_dividends_path(stock)

        expect(response).to have_http_status(:success)
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access dividends index page' do
        get stock_dividends_path(stock)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /investents/stock/:id/dividends' do
    let!(:params) { { stock_id: stock.id, value: 1_000, date: Date.current } }
    let(:new_dividend) { post stock_dividends_path(stock_id: stock.id), params: { dividend: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Dividend' do
        expect { new_dividend }.to change(Investments::Stock::Dividend, :count).by(1)
      end

      it 'has flash notice' do
        new_dividend

        expect(flash[:notice]).to eq('Dividend successfully created.')
      end

      it 'redirects to dividends_path' do
        new_dividend

        expect(response).to redirect_to stock_path(stock)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: Date.current } }
      let(:invalid_dividend) do
        post stock_dividends_path(stock_id: stock.id),
             params: { dividend: invalid_params }
      end

      it 'does not create a new dividend' do
        expect { invalid_dividend }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
