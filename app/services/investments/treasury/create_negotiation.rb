module Investments
  module Treasury
    class CreateNegotiation < ApplicationService
      def initialize(params)
        @params = params
        @date = set_date
        @invested = params.fetch(:invested, 0)
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_negotiation(params)
      end

      private

      def create_negotiation(params)
        ActiveRecord::Base.transaction do
          Investments::Treasury::Negotiation.create(params)
          Investments::Treasury::CreatePosition.new(params).perform
          # puts '------------------', params
          Transactions::CreateExpense.perform(expense_params)
        end
      end

      attr_reader :params, :date, :invested, :treasury

      def expense_params
        {
          account_id: treasury.account.id,
          value: invested,
          title: "Invested in #{treasury.name}",
          date: date,
          kind: 'investment'
        }
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        params.fetch(:date)
      end
    end
  end
end
