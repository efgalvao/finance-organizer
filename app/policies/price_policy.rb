class PricePolicy < ApplicationPolicy
  attr_reader :user, :price

  def initialize(user, price)
    super
    @user = user
    @price = price
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
