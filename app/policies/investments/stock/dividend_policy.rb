module Investments
  module Stock
    class DividendPolicy < ApplicationPolicy
      attr_reader :user, :dividend

      def initialize(user, dividend)
        super
        @user = user
        @dividend = dividend
      end

      class Scope < Scope
        def resolve
          Stock.includes(:account, :dividends).where(account: { user_id: @user.id }).order(:name)
        end
      end

      private

      def owner?
        record.user == user
      end
    end
  end
end
