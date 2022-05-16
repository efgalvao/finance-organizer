require 'rails_helper'

RSpec.describe Investments::Stock::CreateDividend, type: :service do
  let(:account) { create(:account) }
  let(:stock) { create(:stock, account: account) }

  describe '#perform' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, value: 1 } }

      it 'creates a new Price' do
        expect { described_class.new(params).perform }.to change(Investments::Stock::Dividend, :count).by(1)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc' } }

      it 'creates a new Price' do
        expect { described_class.new(invalid_params).perform }.to change(Investments::Stock::Dividend, :count).by(0)
      end
    end
  end
end
