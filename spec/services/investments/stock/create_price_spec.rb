require 'rails_helper'

RSpec.describe Investments::Stock::CreatePrice, type: :service do
  let(:account) { create(:account) }
  let(:stock) { create(:stock, account: account, shares_total: 2, current_value_cents: 0) }

  describe '#perform' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, value: 1, date: Date.current } }

      it 'creates a new Price' do
        expect { described_class.new(params).perform }.to change(Investments::Stock::Price, :count).by(1)
      end

      it 'updates the stock' do
        described_class.new(params).perform

        stock.reload

        expect(stock.current_value_cents).to eq(200)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: Date.current } }

      it 'creates a new Price' do
        expect { described_class.new(invalid_params).perform }.to change(Investments::Stock::Price, :count).by(0)
      end

      it 'does not updates the stock' do
        described_class.new(invalid_params).perform

        stock.reload

        expect(stock.current_value_cents).to eq(0)
      end
    end
  end
end
