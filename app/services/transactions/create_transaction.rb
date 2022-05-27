module Transactions
  class CreateTransaction < ApplicationService
    def initialize(params)
      @params = params
    end

    def perform
      if params[:kind] == 'income'
        Transactions::CreateIncome.new(params).perform
      else
        Transactions::CreateExpense.new(params).perform
      end
    end

    private

    attr_reader :params
  end
end
