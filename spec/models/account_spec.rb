require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account, balance: 100) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:balances) }
    it { is_expected.to have_many(:stocks) }
    it { is_expected.to have_many(:sender_transference) }
    it { is_expected.to have_many(:receiver_transference) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#total_invested' do
    let(:stock1) { create(:stock, account: account) }
    let!(:share1) { create_list(:share, 2, stock: stock1, aquisition_value: 100) }
    let(:stock2) { create(:stock, account: account) }
    let!(:share2) { create_list(:share, 2, stock: stock2, aquisition_value: 100) }

    it 'returns the total invested in the account' do
      expect(account.total_invested.fractional).to eq(40_000)
    end
  end

  describe '#total_stock_value' do
    let(:stock1) { create(:stock, account: account) }
    let!(:share1) { create_list(:share, 2, stock: stock1, aquisition_value: 100) }
    let(:stock2) { create(:stock, account: account) }
    let!(:share2) { create_list(:share, 2, stock: stock2, aquisition_value: 100) }

    it 'returns the total invested in the account' do
      expect(account.total_stock_value.fractional).to eq(40_000)
    end
  end

  describe '#stock_plus_balance' do
    let(:stock1) { create(:stock, account: account) }
    let!(:share1) { create_list(:share, 2, stock: stock1, aquisition_value: 100) }
    let(:stock2) { create(:stock, account: account) }
    let!(:share2) { create_list(:share, 2, stock: stock2, aquisition_value: 100) }

    it 'returns the total invested in the account' do
      expect(account.stock_plus_balance.fractional).to eq(50_000)
    end
  end

  describe '#last_balance' do
    let(:account2) { create(:account, balance: 0) }
    let!(:current_balance) { account2.balances.create(balance_cents: 120) }
    let!(:past_balance) { account2.balances.create(balance_cents: 200, date: (DateTime.current - 1.month)) }

    it 'returns the total invested in the account' do
      expect(account2.last_balance.balance_cents).to eq(120)
    end
  end

  describe '#current_month_transactions' do
    let(:transaction1) { create(:transaction, account: account) }
    let(:transaction2) { create(:transaction, account: account, date: DateTime.current - 1.month) }

    it 'returns current month transaction' do
      expect(account.current_month_transactions).to eq([transaction1])
    end
  end

  describe '#last_semester_total_dividends_received' do
    let(:stock1) { create(:stock, account: account) }
    let!(:share1) { create_list(:share, 2, stock: stock1, aquisition_value: 100, aquisition_date: DateTime.current - 10.days) }
    let!(:dividend1) { create(:dividend, stock: stock1, value: 50, date: DateTime.current - 2.days) }

    it 'returns the total dividends received in the last semester as a hash', :aggregate_failures do
      expect(account.last_semester_total_dividends_received).to be_instance_of(Hash)
      expect(account.last_semester_total_dividends_received).not_to be_empty
    end
  end
end
