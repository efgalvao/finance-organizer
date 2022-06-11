require 'rails_helper'

RSpec.describe Investments::Stock::CreateDividend, type: :service do
  let(:account) { create(:account, :with_balance, balance_cents: 0) }
  let(:stock) { create(:stock, :with_shares, account: account) }

  describe '#call' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, value: 1, date: Date.current } }

      it 'creates a new dividend' do
        expect { described_class.call(params) }.to change(Investments::Stock::Dividend, :count).by(1)
      end

      it 'updates the account balance' do
        described_class.call(params)

        account.reload

        expect(account.balance_cents).to eq((stock.shares_total * params[:value]) * 100)
      end

      it 'creates a new transaction' do
        expect { described_class.call(params) }.to change(Account::Transaction, :count).by(1)
      end
    end

    context 'with invalid data' do
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: Date.current } }

      it 'does not create a new dividend' do
        expect { described_class.call(invalid_params) }.to change(Investments::Stock::Dividend, :count).by(0)
      end

      it 'does not update the account balance' do
        described_class.call(invalid_params)

        account.reload

        expect(account.balance_cents).to eq(0)
      end

      it 'does not create a new transaction' do
        expect { described_class.call(invalid_params) }.not_to change(Account::Transaction, :count)
      end
    end
  end
end
