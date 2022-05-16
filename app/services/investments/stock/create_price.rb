module Investments
  module Stock
    class CreatePrice < ApplicationService
      def initialize(params)
        @params = params
      end

      def perform
        create_price(params)
      end

      private

      def create_price(params)
        ActiveRecord::Base.transaction do
          Investments::Stock::Price.create(params)
          Investments::Stock::UpdateStock.new(params).perform
        end
      end

      attr_reader :params
    end
  end
end
