module Investments
  module Stock
    class CreatePrice < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = set_date
        @stock_id = params[:stock_id]
      end

      def perform
        create_price(params)
      end

      private

      attr_reader :params, :value, :date, :stock_id

      def create_price(params)
        ActiveRecord::Base.transaction do
          Investments::Stock::Price.create(price_params)
          Investments::Stock::UpdateStock.new(params).perform
        end
      end

      def set_date
        if params[:date] == ''
          Time.zone.today
        else
          params.fetch(:date)
        end
      end

      def price_params
        { value: value, date: date, stock_id: stock_id }
      end
    end
  end
end
