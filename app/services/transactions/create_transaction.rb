module Transactions
  class CreateTransaction < ApplicationService
    def initialize(params)
      @params = params
      @account = Account::Account.find(params[:account_id])
      @value = params.fetch(:value, 0)
      @kind = params.fetch(:kind, 'income')
      @date = set_date
      @title = params.fetch(:title)
      @category_id = params.fetch(:category_id, nil)
    end

    def self.call(params)
      new(params).call
    end

    def call
      create_transaction
    end

    private

    attr_reader :params, :account, :value, :kind, :date, :title, :category_id

    def create_transaction
      Account::Transaction.create!(
        account: account,
        category_id: category_id,
        value: value,
        kind: kind,
        date: date,
        title: title
      )
    end

    def set_date
      return Time.zone.today if params.fetch(:date) == ''

      params.fetch(:date)
    end
  end
end
