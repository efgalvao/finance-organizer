module Investments
  module Treasury
    class ReleaseTreasury < ApplicationService
      def initialize(params)
        @params = params
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @released_at = params.fetch(:released_at) { Time.current }
        @released_value = params.fetch(:released_value) { treasury.positions.last }
      end

      def self.call(params)
        new(params).call
      end

      def call
        release_treasury(params)
      end

      private

      attr_reader :params, :treasury, :released_at, :released_value

      def release_treasury(_params)
        ActiveRecord::Base.transaction do
          # treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
          treasury.released_at = released_at
          treasury.released_value = released_value
          binding.pry
          Transactions::ProcessTransaction.call(transaction_params)
          treasury.save!
        end
      end

      def transaction_params
        {
          account_id: treasury.account_id,
          value: released_value,
          kind: 'income',
          date: released_at,
          title: "Treasury released - #{treasury.name}"
        }
      end
    end
  end
end
