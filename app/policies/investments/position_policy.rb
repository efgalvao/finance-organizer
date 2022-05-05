module Investments
  class PositionPolicy < ApplicationPolicy
    attr_reader :user, :position

    def initialize(user, position)
      super
      @user = user
      @position = position
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
