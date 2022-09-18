require 'rails_helper'

RSpec.describe Investments::Stock::CreateDividend, type: :service do
  let(:account) { create(:account, balance_cents: 0) }
  let(:stock) { create(:stock, :with_shares, account: account) }

  describe '#call' do
    context 'with valid data' do
      let(:params) { { stock_id: stock.id, value: 1, date: '2019-09-22' } }

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
      let(:invalid_params) { { stock_id: stock.id, value: 'abc', date: '2019-09-22' } }

      it 'does not create a new dividend' do
        expect { described_class.call(invalid_params) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
