RSpec.describe 'Investments::Stock::CreatePrice', type: :service do
  let(:account) { create(:account) }
  let(:stock) { create(:stock, account: account, shares_total: 2) }

  describe '#perform' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, price: 1_000 } }

      it 'creates a new Price' do
        expect { described_class.new(params).perform }.to change(Investments::Stock::Price, :count).by(1)
      end
    end
  end
end
