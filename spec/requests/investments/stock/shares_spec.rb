require 'rails_helper'

RSpec.describe 'Share', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST /investments/stocks/:id/shares' do
    subject(:post_share) { post stock_shares_path(stock), params: { share: params } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { { stock_id: stock.id, invested: 1_000, date: Date.current } }

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
      let(:params) { { stock_id: stock.id, invested: 'abc', date: Date.current } }

      it 'does not create a new share' do
        post_share

        expect { post_share }.not_to change(Investments::Stock::Share, :count)
      end
    end
  end
end
