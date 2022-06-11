require 'rails_helper'

RSpec.describe Investments::Stock::Stock, type: :model do
  let(:account) { create(:account, name: 'Account 1') }
  let(:stock) { create(:stock, account: account, ticker: 'Stock 1') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticker) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:dividends).dependent(:destroy) }
    it { is_expected.to have_many(:shares).dependent(:destroy) }
    it { is_expected.to have_many(:prices).dependent(:destroy) }
  end

  describe '#ticker_with_account' do
    it { expect(stock.ticker_with_account).to eq('Stock 1 (Account 1)') }
  end

  describe '#average_aquisition_price' do
    let(:stock2) { create(:stock, invested_value: 100, shares_total: 10) }

    context 'when shares_total is not zero' do
      it 'returns average aquisition value' do
        expect(stock2.average_aquisition_price.to_i).to eq(10)
      end
    end

    context 'when shares_total is zero' do
      let(:stock_with_no_shares) { create(:stock, invested_value: 100, shares_total: 0) }

      it 'returns average aquisition value' do
        expect(stock.average_aquisition_price.to_i).to eq(0)
      end
    end
  end

  describe '#last_semester_prices' do
    context 'without prices' do
      it 'returns empty hash' do
        expect(stock.last_semester_prices).to eq({})
      end
    end

    context 'with prices' do
      let!(:price) { create(:price, stock: stock, date: Date.new(2022, 1, 2), value: 123) }

      it 'returns last semester prices' do
        expect(stock.last_semester_prices).to eq({ 'January 02, 2022' => 123.0 })
      end
    end
  end

  # describe '#last_semester_individual_dividends' do
  #   context 'without dividends' do
  #     it 'returns empty hash' do
  #       expect(stock.last_semester_individual_dividends).to eq({})
  #     end
  #   end

  #   context 'with prices' do
  #     let!(:dividend) { create(:dividend, stock: stock, date: Date.new(2022, 0o1, 0o2), value: 123) }

  #     it 'returns last semester prices', :agreggate_failures do
  #       expect(stock.last_semester_individual_dividends).to eq({ 'January/2022' => 123.0 })
  #       expect(stock.last_semester_individual_dividends).not_to be({})
  #     end
  #   end
  # end
end
