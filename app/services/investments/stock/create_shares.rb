module Investments
  module Stock
    class CreateShares < ApplicationService
      def initialize(params)
        @params = params
        @stock = Investments::Stock::Stock.find(params[:stock_id])
        @quantity = params.fetch(:quantity, 0)
        @date = set_date
        @invested = params.fetch(:invested, 0)
      end

      def perform
        valid_share = create_share
        return unless valid_share

        Transactions::CreateExpense.perform({
                                              account_id: stock.account.id,
                                              value: invested.to_f,
                                              title: "Invested in #{stock.ticker} shares",
                                              date: date,
                                              kind: 'investment'
                                            })
      end

      private

      attr_reader :params, :stock, :quantity, :date, :invested

      def create_share
        ActiveRecord::Base.transaction do
          Investments::Stock::Share.create(share_params)
          Investments::Stock::UpdateStock.new(params).perform
        end
      end

      def share_params
        { date: date, quantity: quantity, invested: invested, stock_id: stock.id }
      end

      def set_date
        return Time.zone.today if params.fetch(:date).empty?

        params.fetch(:date)
      end
    end
  end
end
