module Investments
  module Treasury
    class CreatePosition < ApplicationService
      def initialize(params)
        @params = params
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_position
      end

      private

      attr_reader :params, :treasury

      def create_position
        ActiveRecord::Base.transaction do
          position = Investments::Treasury::Position.create!(position_params)
          Investments::Treasury::UpdateTreasury.call(update_treasury_params)
          position
        end
      end

      def position_params
        {
          treasury_id: treasury.id,
          date: set_date,
          amount: set_new_position_value
        }
      end

      def update_treasury_params
        {
          treasury_id: treasury.id,
          date: set_date,
          updated_invested: set_new_invested_value,
          updated_current: set_new_current_value,
          shares: params[:shares]
        }
      end

      def to_cents(value)
        (value.to_f * 100).to_i
      end

      def set_new_position_value
        return params[:amount] if params[:amount].present?

        params.fetch(:invested, 0).to_f + treasury.current_value_cents / 100.0
      end

      def set_new_invested_value
        return treasury.invested_value_cents if params[:amount].present?

        to_cents(params.fetch(:invested, 0)) + treasury.invested_value_cents
      end

      def set_new_current_value
        return to_cents(params[:amount]) if params[:amount].present?

        to_cents(params.fetch(:invested, 0)) + treasury.current_value_cents
      end

      def set_date
        return Time.zone.today if params.fetch(:date, '') == ''

        params.fetch(:date)
      end
    end
  end
end
