require 'rails_helper'

RSpec.describe User, type: :model do
  let(:account) { create(:account, user: user) }
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:accounts) }
    it { is_expected.to have_many(:user_reports) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '#total_amount' do
    context 'without balance' do
      it { expect(user.total_amount).to eq(0) }
    end

    context 'with balance' do
      let!(:balance) { create(:balance, account: account, balance_cents: 1000) }

      it { expect(user.total_amount.fractional).to eq(1000) }
    end
  end

  describe '#total_balance' do
    context 'without balance' do
      it { expect(user.total_balance).to eq(0) }
    end

    context 'with balance' do
      let(:stock_account) { create(:account, :stocks_account, user: user) }
      let!(:balance) { create(:balance, account: account, balance_cents: 1000) }
      let!(:balance2) { create(:balance, account: stock_account, balance_cents: 1123) }

      it 'returns total accounts balance' do
        expect(user.total_balance.fractional).to eq(2123)
      end
    end
  end

  describe '#total_in_stocks' do
    context 'without stocks' do
      it { expect(user.total_in_stocks).to eq(0) }
    end

    context 'with balance' do
      let(:stock_account) { create(:account, :stocks_account, user: user) }
      let(:stock) { create(:stock, account: stock_account) }
      let!(:share) { create(:share, stock: stock, aquisition_value: 100) }

      it 'return current total stock amount' do
        expect(user.total_in_stocks.fractional).to eq(10_000)
      end
    end
  end

  describe '#last_semester_total_dividends' do
    context 'without dividends' do
      it { expect(user.last_semester_total_dividends).to eq({}) }
    end

    context 'with dividends' do
      let(:stock_account) { create(:account, :stocks_account, user: user) }
      let(:stock) { create(:stock, account: stock_account) }
      let!(:share) { create_list(:share, 3, stock: stock, aquisition_value: 100, aquisition_date: DateTime.current - 10.days) }
      let!(:dividend) { create(:dividend, stock: stock, date: Time.zone.today, value: 123) }

      it 'return hash', :aggregate_failures do
        expect(user.last_semester_total_dividends).to eq({ 'January/2022' => 369.0 })
        expect(user.last_semester_total_dividends).not_to eq({})
      end
    end
  end
end
