module Investments
  module Treasury
    class CreateTreasury < ApplicationService
      def initialize(treasury_params)
        @params = treasury_params
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_treasury(params)
      end

      private

      def create_treasury(params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Treasury.create(params)
        end
      end

      attr_reader :params
    end
  end
end
