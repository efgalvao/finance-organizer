module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = params.fetch(:date, Date.today)
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def perform
        return unless create_dividend.valid?

        Transactions::CreateIncome.perform({
                                             account_id: stock.account.id,
                                             value: (value.to_f * stock.shares_total),
                                             title: "#{stock.ticker} Dividend",
                                             date: date
                                           })
      end

      private

      attr_reader :value, :date, :stock, :params

      def create_dividend
        Investments::Stock::Dividend.create(params)
      end
    end
  end
end
