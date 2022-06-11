module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @params = params
        @ticker = params.fetch(:ticker, '')
        @quantity = params.fetch(:quantity, 0)
        @invested = params.fetch(:invested, 0).to_f * 100
        @value = params.fetch(:value, nil)
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def self.call(params)
        new(params).call
      end

      def call
        update_stock
      end

      private

      attr_reader :params, :stock, :ticker, :quantity, :invested, :value

      def update_stock
        ActiveRecord::Base.transaction do
          stock.ticker = ticker.empty? ? stock.ticker : ticker
          stock.shares_total += quantity.to_i
          stock.invested_value_cents += invested
          stock.current_value_cents = new_current_value
          stock.current_total_value_cents = new_current_total_value
          stock.save
        end
      end

      def new_current_value
        if value.nil?
          stock.current_value_cents
        else
          value.to_f * 100.0
        end
      end

      def new_current_total_value
        if value.nil?
          stock.current_value_cents * stock.shares_total
        else
          (value.to_f * 100) * stock.shares_total
        end
      end
    end
  end
end
