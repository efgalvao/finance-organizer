module Investments
  module Treasury
    class CreateNegotiation < ApplicationService
      def initialize(params)
        @params = params
      end

      def perform
        create_negotiation(params)
      end

      private

      def create_negotiation(params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Negotiation.create(params)
          Investments::Treasury::CreatePosition.new(params).perform
        end
      end

      attr_reader :params
    end
  end
end
