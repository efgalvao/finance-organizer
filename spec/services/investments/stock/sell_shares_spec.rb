require 'rails_helper'

RSpec.describe Investments::Stock::SellShares, type: :service do
  let(:account) { create(:account) }

  describe '#call' do
    context 'with valid data' do
      context 'when selling all shares' do
        let(:stock) { create(:stock, account: account, shares_total: 1, current_value_cents: 100) }
        let!(:share) { create(:share, stock_id: stock.id, quantity: 1, date: DateTime.current) }
        let(:params) { { stock_id: stock.id, received: 100, quantity: 1, date: Date.current.strftime('%Y-%m-%d') } }

        it 'remove share' do
          expect { described_class.call(params) }.to change(Investments::Stock::Share, :count).by(-1)
        end

        it 'updates the stock', :aggregate_failures do
          described_class.call(params)
          stock.reload

          expect(stock.shares_total).to eq(0)
          # expect(stock.current_value_cents).to eq(0)
          expect(stock.current_total_value_cents).to eq(0)
        end
      end

      context 'when selling partial shares' do
        let(:stock) { create(:stock, account: account, shares_total: 2, current_value_cents: 100, current_total_value_cents: 200) }
        let!(:share) { create(:share, stock_id: stock.id, quantity: 2, date: DateTime.current) }
        let(:params) { { stock_id: stock.id, received: 50, quantity: 1, date: Date.current.strftime('%Y-%m-%d') } }

        it 'does not remove share' do
          expect { described_class.call(params) }.to change(Investments::Stock::Share, :count).by(0)
        end

        it 'updates the stock', :aggregate_failures do
          described_class.call(params)
          stock.reload

          expect(stock.shares_total).to eq(1)
          expect(stock.current_total_value_cents).to eq(100)
        end
      end
    end

    context 'with invalid data' do
      let(:stock) { create(:stock, account: account, shares_total: 1, current_value_cents: 100) }
      let!(:share) { create(:share, stock_id: stock.id, quantity: 1, date: DateTime.current) }
      let(:invalid_params) { { stock_id: stock.id, received: 'abc', date: Date.current.strftime('%Y-%m-%d') } }

      it 'does not remove share' do
        expect { described_class.call(invalid_params) }.to change(Investments::Stock::Share, :count).by(0)
      end

      it 'does not updates the stock' do
        described_class.call(invalid_params)

        stock.reload

        expect(stock.current_value_cents).to eq(100)
        expect(stock.shares_total).to eq(1)
      end
    end
  end
end
