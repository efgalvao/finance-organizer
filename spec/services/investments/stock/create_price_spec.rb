require 'rails_helper'

RSpec.describe Investments::Stock::CreatePrice, type: :service do
  let(:account) { create(:account) }
  let(:stock) { create(:stock, account: account, shares_total: 2, current_value_cents: 0) }

  describe '#call' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, value: 1, date: Date.current } }

      it 'creates a new Price' do
        expect { described_class.call(params) }.to change(Investments::Stock::Price, :count).by(1)
      end

      it 'updates the stock' do
        described_class.call(params)
        stock.reload

        expect(stock.current_value_cents).to eq(100)
        expect(stock.current_total_value_cents).to eq(200)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: Date.current } }

      it 'creates a new Price' do
        expect { described_class.call(invalid_params) }.to change(Investments::Stock::Price, :count).by(0)
      end

      it 'does not updates the stock' do
        described_class.call(invalid_params)

        stock.reload

        expect(stock.current_value_cents).to eq(0)
      end
    end
  end
end
