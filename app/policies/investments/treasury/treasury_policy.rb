module Investments
  module Treasury
    class TreasuryPolicy < ApplicationPolicy
      attr_reader :user, :treasury

      def initialize(user, treasury)
        super
        @user = user
        @treasury = treasury
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

      def summary?
        owner?
      end

      class Scope < Scope
        def resolve
          Treasury.includes(:account).where(account: { user_id: @user.id })
        end
      end

      private

      def owner?
        treasury.account.user == user
      end
    end
  end
end
