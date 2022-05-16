module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
      end

      def perform
        create_dividend(params)
      end

      private

      def create_dividend(params)
        ActiveRecord::Base.transaction do
          Investments::Stock::Dividend.create(params)
        end
      end

      attr_reader :params
    end
  end
end
