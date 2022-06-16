module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = set_date
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def self.call(params)
        new(params).call
      end

      def call
        return create_dividend unless create_dividend.valid?

        #refatorar para usar o create_transaction e o update_account_balance
        Transactions::CreateIncome.call({
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
        return Time.zone.today if params.fetch(:date) == ''

        params.fetch(:date)
      end
    end
  end
end
