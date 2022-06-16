module Investments
  module Stock
    class CreateShares < ApplicationService
      def initialize(params)
        @params = params
        @stock = Investments::Stock::Stock.find(params[:stock_id])
        @quantity = params.fetch(:quantity, 0).to_i
        @date = set_date
        @invested = params.fetch(:invested, 0).to_f
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_share
      end

      private

      attr_reader :params, :stock, :quantity, :date, :invested

      def create_share
        ActiveRecord::Base.transaction do
          Investments::Stock::Share.create(share_params)
          Investments::Stock::UpdateStock.call(update_stock_params)
          # refatorar para usar o create_transaction e o update_account_balance
          Transactions::CreateExpense.call({
                                             account_id: stock.account.id,
                                             value: invested,
                                             title: "Invested in #{stock.ticker} shares",
                                             date: date,
                                             kind: 'investment'
                                           })
        end
      end

      def share_params
        { date: date, quantity: quantity, invested: invested, stock_id: stock.id }
      end

      def update_stock_params
        { date: date, quantity: quantity, invested: invested, stock_id: stock.id, value: (invested / quantity) }
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        params.fetch(:date)
      end
    end
  end
end
