module Investments
  module Treasury
    class UpdateTreasury < ApplicationService
      def initialize(params)
        @params = params
      end

      def self.call(params)
        new(params).call
      end

      def call
        update_treasury(params)
      end

      private

      def update_treasury(params)
        ActiveRecord::Base.transaction do
          treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
          treasury.name = params.fetch(:name) { treasury.name }
          treasury.shares += params.fetch(:shares, 0).to_i
          treasury.invested_value_cents = params.fetch(:updated_invested, 0)
          treasury.current_value_cents = params.fetch(:updated_current, 0)
          treasury.save
        end
      end

      attr_reader :params
    end
  end
end
