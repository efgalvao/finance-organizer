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
      balance = account.balances.current
      if balance.nil?
        account.balances.create(balance: amount)
      else
        balance.balance_cents += amount.to_f * 100
      end

      balance.save
    end
  end
end
