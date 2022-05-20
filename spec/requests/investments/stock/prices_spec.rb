require 'rails_helper'

RSpec.describe 'Price', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST /investments/stocks/:id/prices' do
    let!(:params) { { stock_id: stock.id, price: 1_000, date: Date.current } }
    let(:new_price) { post stock_prices_path(stock), params: { price: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Price' do
        expect { new_price }.to change(Investments::Stock::Price, :count).by(1)
      end

      it 'has flash notice' do
        new_price

        expect(flash[:notice]).to eq('Price successfully created.')
      end

      it 'redirects to prices_path' do
        new_price

        expect(response).to redirect_to stock_path(stock)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: Date.current } }
      let(:invalid_price) do
        post stock_prices_path(stock_id: stock.id), params: { price: invalid_params }
      end

      it 'does not create a new price' do
        expect { invalid_price }.not_to change(Investments::Stock::Price, :count)
      end
    end
  end
end
