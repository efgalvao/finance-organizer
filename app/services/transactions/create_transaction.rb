module Transactions
  class CreateTransaction < ApplicationService
    def initialize(params)
      @params = params
    end

    def perform
      transaction = create_transaction(params)
      update_account_balance(transaction) if transaction.valid?
      transaction
    end

    private

    attr_reader :params

    def create_transaction(params)
      Transaction.new(params)
    end

    def update_account_balance(transaction)
      account = transaction.account
      amount = transaction.value
      if transaction.kind == 'income'
        account.update_balance(amount)
      else
        account.update_balance(-amount)
      end
    end
  end
end
