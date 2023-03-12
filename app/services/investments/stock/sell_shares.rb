module Investments
  module Stock
    class SellShares < ApplicationService
      def initialize(params)
        @stock_id = params[:stock_id]
        @quantity = params.fetch(:quantity, 0).to_i
        @date = format_date(params.fetch(:date))
        @received = params.fetch(:received, 0).to_f
      end

      def self.call(params)
        new(params).call
      end

      def call
        return false if quantity.zero?

        sell_share

        zero_stock if stock.shares_total.zero?
      rescue StandardError
        false
      end

      private

      attr_reader :stock_id, :quantity, :date, :received

      def sell_share
        ActiveRecord::Base.transaction do
          update_shares
          Transactions::ProcessTransaction.call(transactions_params)
          Investments::Stock::UpdateStock.call(update_stock_params)
        end
      end

      def update_shares
        shares_to_sell = quantity
        received_cents = received * 100
        stock.shares.each do |share|
          next if shares_to_sell.zero?

          share.quantity -= shares_to_sell
          if share.quantity > shares_to_sell
            share.invested_cents -= received_cents
            shares_to_sell = 0
            received_cents = 0
          elsif share.quantity == shares_to_sell
            share.invested_cents = 0
            shares_to_sell = 0
          else
            share.invested_cents -= received_cents
            shares_to_sell -=  share.quantity
            received_cents -= share.invested_cents
          end
          share.save!
        end
      end

      def stock
        @stock = Investments::Stock::Stock.includes(:shares).find(stock_id)
      end

      def transactions_params
        {
          account_id: stock.account.id,
          value: received,
          title: "#{stock.ticker} sold",
          date: date,
          kind: 'income'
        }
      end

      def update_stock_params
        {
          date: date,
          quantity: -quantity,
          invested: -received,
          stock_id: stock_id,
          value: stock.current_value
        }
      end

      def format_date(date)
        return Time.zone.today if date == ''

        DateTime.parse(date)
      end

      def zero_stock
        stock.update(
          invested_value_cents: 0, current_value_cents: 0
        )

        stock.shares = []
        stock.save!
      end
    end
  end
end
