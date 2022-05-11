module Investments
  module Treasury
    class UpdateTreasury < ApplicationService
      def initialize(params)
        @params = params
      end

      def perform
        update_treasury(params)
      end

      private

      def update_treasury(params)
        ActiveRecord::Base.transaction do
          treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
          treasury.name = params.fetch(:name) { treasury.name }
          treasury.shares += params.fetch(:shares, 0).to_i
          treasury.invested_value_cents += (params.fetch(:invested, 0).to_f * 100)
          treasury.current_value_cents = new_current_value(treasury.current_value_cents)
          treasury.save
        end
      end

      def new_current_value(value)
        if params[:amount]
          params[:amount].to_f * 100
        else
          value + params[:invested].to_f * 100
        end
      end

      attr_reader :params
    end
  end
end
