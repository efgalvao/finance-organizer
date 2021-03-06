module Investments
  module Stock
    class StockPolicy < ApplicationPolicy
      attr_reader :user, :stock

      def initialize(user, stock)
        super
        @user = user
        @stock = stock
      end

      def edit?
        owner?
      end

      def show?
        owner?
      end

      def update?
        owner?
      end

      def destroy?
        owner?
      end

      class Scope < Scope
        def resolve
          Stock.includes(:account).where(account: { user_id: @user.id })
        end
      end

      private

      def owner?
        record.account.user == user
      end
    end
  end
end
