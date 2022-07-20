require 'rails_helper'

RSpec.describe 'Stock', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let!(:stock) { create(:stock, account: account) }

  describe 'GET /stocks/:id/edit' do
    context 'when logged in' do
      it 'can successfully access an stock edit page' do
        sign_in(user)

        get edit_stock_path(stock)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a stock edit page' do
        get edit_stock_path(stock)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /investments/stocks/stocks/:id' do
    context 'when logged' do
      let(:expected_ticker) { 'NFLX' }

      before { sign_in(user) }

      it 'can successfully update a stock' do
        put stock_path(stock), params: {
          stock: {
            ticker: expected_ticker
          }
        }

        stock.reload
        expect(stock.ticker).to eq(expected_ticker)
        expect(response).to redirect_to stock_path(stock)
        expect(response.request.flash[:notice]).to eq 'Stock successfully updated.'
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update stock' do
        put stock_path(stock), params: {
          stock: {
            name: nil
          }
        }

        stock.reload
        expect(stock.ticker).not_to be_nil
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a stock' do
        put stock_path(stock), params: {
          stock: {
            name: 'NFLX'
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /stocks' do
    let(:account) { create(:account) }

    before { sign_in(user) }

    context 'with valid data' do
      let(:new_stock) { post stocks_path, params: { stock: params } }
      let(:params) { { ticker: 'SLFI', account_id: account.id } }

      it 'creates a new Stock' do
        expect { new_stock }.to change(Investments::Stock::Stock, :count).by(1)
      end

      it 'has flash notice' do
        new_stock

        expect(flash[:notice]).to eq('Stock successfully created.')
      end

      it 'redirects to stock_path' do
        new_stock

        expect(response).to redirect_to stock_path(Investments::Stock::Stock.find_by(ticker: 'SLFI'))
      end
    end

    context 'with invalid data' do
      let!(:invalid_params) { { ticker: nil, account_id: account.id } }
      let(:invalid_stock) { post stocks_path, params: { stock: invalid_params } }

      it 'does not create a new stock' do
        expect { invalid_stock }.not_to change(Investments::Stock::Stock, :count)
      end
    end
  end

  describe 'DELETE /stocks/:id   ' do
    let!(:new_stock) { create(:stock, account: account) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a stock', :aggregate_failures do
        expect { delete stock_path(new_stock) }.to change(Investments::Stock::Stock, :count).by(-1)
        expect(flash[:notice]).to eq 'Stock successfully removed.'
        expect(response).to redirect_to stocks_path
      end
    end
  end

  describe 'GET /stocks' do
    context 'when logged in' do
      it 'can successfully access stocks index page' do
        sign_in(user)

        get stocks_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a stocks index page' do
        get stocks_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /stocks/:id' do
    context 'when logged in' do
      it 'can successfully access stock show page' do
        sign_in(user)

        get stock_path(stock)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a stock summary page' do
        get stock_path(stock)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /stocks/new' do
    context 'when logged in' do
      it 'can successfully access an new stock page' do
        sign_in(user)

        get new_stock_path(account_id: account.id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new stock page' do
        get new_stock_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
