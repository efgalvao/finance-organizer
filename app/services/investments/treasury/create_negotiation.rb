module Investments
  module Treasury
    class CreateNegotiation < ApplicationService
      def initialize(params)
        @params = params
        @date = set_date
        @invested = params.fetch(:invested, 0)
        @shares = params.fetch(:shares, 0)
        @kind = params.fetch(:kind, 'buy')
        @treasury = Investments::Treasury::Treasury.find(params.fetch(:treasury_id))
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_negotiation(params)
      end

      private

      def create_negotiation(_params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Negotiation.create!(negotiation_params)
          Investments::Treasury::CreatePosition.call(create_position_params)
          Transactions::ProcessTransaction.call(transactions_params)
        end
      end

      attr_reader :params, :date, :invested, :treasury, :shares, :kind

      def negotiation_params
        {
          treasury_id: treasury.id,
          kind: kind,
          date: date,
          invested: invested,
          shares: shares
        }
      end

      def transactions_params
        {
          account_id: treasury.account.id,
          value: invested,
          title: "Invested in #{treasury.name}",
          date: date,
          kind: 'investment'
        }
      end

      def create_position_params
        {
          treasury_id: treasury.id,
          shares: shares,
          invested: invested,
          date: date
        }
      end

      def set_date
        return Time.zone.today if params.fetch(:date, '') == ''

        DateTime.parse(params.fetch(:date))
      end
    end
  end
end
