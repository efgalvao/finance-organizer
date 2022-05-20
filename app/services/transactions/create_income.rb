module Transactions
  class CreateIncome < ApplicationService
    def initialize(params)
      @account = Account.find(params[:account_id])
      @value = params.fetch(:value, 0)
      @kind = params.fetch(:kind, 'income')
      @date = params.fetch(:date, Time.zone.today)
      @title = params.fetch(:title)
    end

    def perform
      create_transaction
    end

    private

    attr_reader :account, :value, :kind, :date, :title

    def create_transaction
      ActiveRecord::Base.transaction do
        Transaction.create(account: account, value: value, kind: kind, date: date, title: title)
        update_account_balance
      end
    end

    def update_account_balance
      account.balance_cents += (value * 100).to_i
      account.save
    end
  end
end
