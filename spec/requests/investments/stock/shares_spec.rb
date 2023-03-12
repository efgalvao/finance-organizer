require 'rails_helper'

RSpec.describe 'Share', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account, shares_total: 1) }

  describe 'POST /investments/stocks/:id/shares' do
    subject(:post_share) { post stock_shares_path(stock), params: { share: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { { stock_id: stock.id, invested: 1_000, quantity: 1, date: Date.current } }

      it 'creates a new Price' do
        expect { post_share }.to change(Investments::Stock::Share, :count).by(1)
      end

      it 'has flash notice' do
        post_share

        expect(flash[:notice]).to eq('Share successfully created.')
      end

      it 'redirects to shares_path' do
        post_share

        expect(response).to redirect_to stock_path(stock)
      end
    end

    context 'with invalid data' do
      let(:params) { { stock_id: stock.id, invested: 0, quantity: 0, date: '2022-09-19' } }

      it 'does not create a new share' do
        expect { post_share }.not_to change(Investments::Stock::Share, :count)
      end
    end
  end

  describe 'POST /investments/stocks/:id/sell_shares' do
    subject(:sell_share) { post stock_sell_shares_path(stock), params: { sell: params } }

    before do
      sign_in(user)
      create(:share, stock_id: stock.id, quantity: 1)
    end

    context 'with valid data' do
      let(:params) { { stock_id: stock.id, received: 1_000, quantity: 1, date: Date.current } }

      it 'creates a new Price' do
        expect { sell_share }.to change(Investments::Stock::Share, :count).by(-1)
      end

      it 'has flash notice' do
        sell_share

        expect(flash[:notice]).to eq('Share successfully sold.')
      end

      it 'redirects to shares_path' do
        sell_share

        expect(response).to redirect_to stock_path(stock)
      end
    end

    context 'with invalid data' do
      let(:params) { { stock_id: stock.id, invested: 'abc', date: '2022-09-19' } }

      it 'does not create a new share' do
        expect { sell_share }.not_to change(Investments::Stock::Share, :count)
      end
    end
  end
end
