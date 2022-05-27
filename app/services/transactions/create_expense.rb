module Transactions
  class CreateExpense < ApplicationService
    def initialize(params)
      @params = params
      @account = Account::Account.find(params[:account_id])
      @value = params.fetch(:value, 0)
      @kind = params.fetch(:kind, 'income')
      @date = set_date
      @title = params.fetch(:title)
      @category_id = params.fetch(:category_id, nil)
    end

    def self.perform(**args)
      new(**args).perform
    end

    def perform
      create_transaction
    end

    private

    attr_reader :params, :account, :value, :kind, :date, :title, :category_id

    def create_transaction
      ActiveRecord::Base.transaction do
        Account::Transaction.create(account: account, category_id: category_id,
                                    value: value, kind: kind, date: date, title: title)
        update_account_balance
      end
    end

    def update_account_balance
      account.balance_cents -= value.to_f * 100
      account.save
    end

    def set_date
      return Time.zone.today if params.fetch(:date).empty?

      params.fetch(:date)
    end
  end
end
