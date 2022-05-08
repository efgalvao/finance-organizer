module Investments
  class NegotiationPolicy < ApplicationPolicy
    def initialize(user, negotiation)
      super
      @user = user
      @negotiation = negotiation
    end

    class Scope < Scope
      def resolve
        @scope.joins(:treasury).where('treasury.account.user_id' => user.id)
      end
    end

    private

    attr_reader :user
end
