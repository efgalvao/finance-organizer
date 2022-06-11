require 'rails_helper'

RSpec.describe User, type: :model do
  # let(:account) { create(:account, user: user) }
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:accounts) }
    it { is_expected.to have_many(:user_reports) }
    it { is_expected.to have_many(:transferences) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '#total_amount' do
    let!(:account) { create(:account, user: user, balance: 100) }

    context 'with balance' do
      it { expect(user.total_amount.to_i).to eq(100) }
    end
  end

  describe '#total_in_stocks' do
    context 'without stocks' do
      it { expect(user.total_in_stocks).to eq(0) }
    end

    context 'with balance' do
      let!(:stock_account) { create(:account, :stocks_account, user: user) }
      let!(:stock) { create(:stock, account: stock_account, current_total_value: 15, shares_total: 1) }
      let!(:stock2) { create(:stock, account: stock_account, current_total_value: 20, shares_total: 1) }

      it 'return current total stock amount' do
        expect(user.total_in_stocks.to_i).to eq(35)
      end
    end
  end
end
