module Investments
  module Treasury
    class CreateTreasury < ApplicationService
      def initialize(treasury_params)
        @params = treasury_params
        @account_id = treasury_params.fetch(:account_id)
        @name = treasury_params.fetch(:name)
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
          Investments::Treasury::Treasury.create(account_id: account_id, name: params.fetch(:name))
        end
      end

      attr_reader :params, :account_id, :name
    end
  end
end
