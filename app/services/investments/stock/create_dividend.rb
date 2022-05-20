module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = set_date
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def perform
        return create_dividend unless create_dividend.valid?

        Transactions::CreateIncome.perform({
                                             account_id: stock.account.id,
                                             value: (value.to_f * stock.shares_total),
                                             title: "#{stock.ticker} dividends",
                                             date: date,
                                             kind: 'income'
                                           })
      end

      private

      attr_reader :value, :date, :stock, :params

      def create_dividend
        Investments::Stock::Dividend.create(dividend_params)
      end

      def dividend_params
        { value: value, date: date, stock_id: stock.id }
      end

      def set_date
        if params[:date] == ''
          Time.zone.today
        else
          params.fetch(:date)
        end
      end
    end
  end
end