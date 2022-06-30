# frozen_string_literals: true

module Account
  class UpdateBalance < ApplicationService
    def initialize(params)
      @account = Account.find(params[:account_id])
      @amount = params.fetch(:amount, 0)
    end

    def self.call(params)
      new(params).call
    end

    def call
      update_balance
    end

    private

    attr_reader :account, :amount

    def update_balance
      balance = account.balances.find_by('date >= ?', DateTime.current - 1.day)
      if balance.nil?
        updated_balance = account.balance.cents / 100.0
        balance = account.balances.create(balance: updated_balance, date: DateTime.current)
        balance
      else
        balance.balance_cents += (amount * 100)
      end
      balance.save
    end
  end
end
