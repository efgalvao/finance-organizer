module Investments
  module Stock
    class CreatePrice < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = set_date
        @stock_id = params[:stock_id]
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_price(params)
      end

      private

      attr_reader :params, :value, :date, :stock_id

      def create_price(params)
        ActiveRecord::Base.transaction do
          price = Investments::Stock::Price.create(price_params)
          Investments::Stock::UpdateStock.new(params).perform
          price
        end
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        params.fetch(:date)
      end

      def price_params
        { value: value, date: date, stock_id: stock_id }
      end
    end
  end
end
