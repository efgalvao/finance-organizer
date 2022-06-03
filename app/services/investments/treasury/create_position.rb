module Investments
  module Treasury
    class CreatePosition < ApplicationService
      def initialize(params)
        @params = params
        @date = set_date
        @invested = params.fetch(:invested, 0)
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @amount = params.fetch(:amount, 0)
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_position(params)
      end

      private

      attr_reader :params, :date, :invested, :amount, :treasury

      def create_position(params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Position.create(position_params(params))
          Investments::Treasury::UpdateTreasury.new(params).perform
        end
      end

      def position_params
        { treasury_id: treasury.id,
          date: date, amount: amount.zero? ? invested : amount }
      end

      def set_date
        return Time.zone.today if params.fetch(:date, '') == ''

        params.fetch(:date)
      end
    end
  end
end
