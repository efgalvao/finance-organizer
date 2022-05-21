module Account
  class CategoryPolicy < ApplicationPolicy
    attr_reader :user, :category

    def initialize(user, category)
      super
      @user = user
      @category = category
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

    def edit?
      owner?
    end

    class Scope < Scope
      def resolve
        @scope.where(user_id: @user.id)
      end
    end

    private

    def owner?
      record.user == user
    end
  end
end
