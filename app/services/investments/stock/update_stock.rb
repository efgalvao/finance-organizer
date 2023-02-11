module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @stock_id = params.fetch(:stock_id)
        @date = params.fetch(:date, Time.current)
        @value = params.fetch(:value, 0).to_f
        @quantity = params.fetch(:quantity, 0)
        @invested = params.fetch(:invested, 0).to_f * 100
      end

      def self.call(params)
        new(params).call
      end

      def call
        update_stock
        update_account_report
      end

      private

      attr_reader :stock_id, :date, :value, :quantity, :invested

      def update_stock
        ActiveRecord::Base.transaction do
          stock.shares_total += quantity.to_i
          stock.invested_value_cents += invested
          stock.current_value_cents = new_current_value_cents
          stock.current_total_value_cents = new_current_total_value_cents
          stock.save!
        end
      end

      def new_current_value_cents
        value * 100
      end

      def new_current_total_value_cents
        if value.zero?
          stock.current_total_value_cents
        else
          (value * 100) * stock.shares_total
        end
      end

      def update_account_report
        AccountReport::UpdateAccountReport.call(account_id: stock.account_id, params: update_report_params)
      end

      def update_report_params
        {
          date: date
        }
      end

      def stock
        @stock ||= Investments::Stock::Stock.find(stock_id)
      end
    end
  end
end
