require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:account) { create(:account, name: 'Account 1') }
  let(:stock) { create(:stock, account: account, name: 'Stock 1') }

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

  describe '#current_price' do
    let(:stock2) { create(:stock) }

    context 'without shares/prices' do
      it 'returns 0' do
        expect(stock2.current_price).to eq(0)
      end
    end

    context 'with shares/prices' do
      let!(:share2) { create(:share, stock: stock2, aquisition_value_cents: 50) }

      it 'return newest aquisition price' do
        expect(stock2.current_price.fractional).to eq(50)
      end
    end
  end

  describe '#total_invested' do
    let!(:shares) { create_list(:share, 2, stock: stock, aquisition_value_cents: 150) }

    it 'returns sum of aquisition values' do
      expect(stock.total_invested).to eq(Money.new(300))
    end
  end

  describe '#average_aquisition_price' do
    let!(:share1) { create(:share, stock: stock, aquisition_value_cents: 200) }
    let!(:share2) { create(:share, stock: stock, aquisition_value_cents: 150) }

    it 'returns average aquisition value' do
      expect(stock.average_aquisition_price).to eq(Money.new(175))
    end
  end

  describe '#total_current_price' do
    context 'without shares/prices' do
      it 'returns 0' do
        expect(stock.total_current_price).to eq(0)
      end
    end

    context 'with shares/prices' do
      let!(:share2) { create(:share, stock: stock, aquisition_value_cents: 50) }

      it 'return newest aquisition price' do
        expect(stock.total_current_price.fractional).to eq(50)
      end
    end

    describe '#updated_balance' do
      context 'without shares/prices' do
        it 'returns 0' do
          expect(stock.updated_balance).to eq(0)
        end
      end

      context 'with shares/prices' do
        let!(:share2) { create(:share, stock: stock, aquisition_value_cents: 50) }

        it 'return newest aquisition price' do
          expect(stock.updated_balance.fractional).to eq(50)
        end
      end
    end
  end
end
