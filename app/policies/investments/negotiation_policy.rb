module Investments
  class NegotiationPolicy < ApplicationPolicy
    attr_reader :user, :negotiation

    def initialize(user, negotiation)
      super
      @user = user
      @negotiation = negotiation
    end

    def update?
      owner?
    end

    def destroy?
      owner?
    end

    def edit?
      owner?
    end

    # class Scope < Scope
    #   def resolve
    #     @scope.where(user_id: @user.id)
    #   end
    # end

    private

    def owner?
      treasury.account_user == user
    end
  end
end
