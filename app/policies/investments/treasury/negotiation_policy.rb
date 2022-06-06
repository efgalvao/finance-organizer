module Investments
  module Treasury
    class NegotiationPolicy < ApplicationPolicy
      def initialize(user, negotiation)
        super
        @user = user
        @negotiation = negotiation
      end

      class Scope < Scope
        def resolve
          @scope.includes(:treasury, treasury: :account).joins(:treasury,
                                                               treasury: :account).where(account: { user_id: user.id })
        end
      end

      private

      attr_reader :user
    end
  end
end
