module Investments
  module Treasury
    class CreatePosition < ApplicationService
      def initialize(params)
        @params = params
      end

      def perform
        create_position(params)
      end

      private

      def create_position(params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Position.create(position_params(params))
          Investments::Treasury::UpdateTreasury.new(params).perform
        end
      end

      def position_params(params)
        { treasury_id: params[:treasury_id],
          date: params[:date], amount: params[:amount] }
      end

      attr_reader :params
    end
  end
end
