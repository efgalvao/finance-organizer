require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:account) { create(:account, name: 'Account 1') }
  let(:stock) { create(:stock, account: account, name: 'Stock 1') }
  let!(:shares) { create_list(:share, 2, stock: stock, aquisition_value: 150) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:dividends).dependent(:destroy) }
    it { is_expected.to have_many(:shares).dependent(:destroy) }
    it { is_expected.to have_many(:prices).dependent(:destroy) }
  end

  describe '#name_with_account' do
    it { expect(stock.name_with_account).to eq('Stock 1 (Account 1)') }
  end

  describe '#total_current_price' do
    it { expect(stock.total_current_price.fractional).to eq(30_000) }
  end

  describe '#average_aquisition_price' do
    it { expect(stock.average_aquisition_price.fractional).to eq(15_000) }
  end

  describe '#individual_price' do
    context 'with price' do
      let(:prices) { create(:price, stock: stock, value: 30_000) }

      it { expect(stock.individual_price.fractional).to eq(15_000) }
    end

    context 'without price' do
      binding.pry
      it { expect(stock.individual_price.fractional).to eq(15_000) }
    end
  end
end
