require 'rails_helper'

RSpec.describe 'Share', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:stock) { create(:stock, account: account) }

  describe 'POST /investments/stocks/:id/shares' do
    let!(:params) { { stock_id: stock.id, invested: 1_000, date: Date.current } }
    let(:new_share) { post stock_shares_path(stock), params: { share: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Price' do
        expect { new_share }.to change(Investments::Stock::Share, :count).by(1)
      end

      it 'has flash notice' do
        new_share

        expect(flash[:notice]).to eq('Share successfully created.')
      end

      it 'redirects to shares_path' do
        new_share

        expect(response).to redirect_to stock_path(stock)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, invested: 'abc', date: Date.current } }
      let(:invalid_share) do
        post stock_shares_path(stock_id: stock.id), params: { share: invalid_params }
      end

      it 'does not create a new share' do
        expect { invalid_share }.not_to change(Investments::Stock::Share, :count)
      end
    end
  end
end
