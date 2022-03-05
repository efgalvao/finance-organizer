class BalancePolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, balance)
    super
    @user = user
    @account = balance.account
  end

  def show?
    account_owner?
  end

  def update?
    account_owner?
  end

  def destroy?
    account_owner?
  end

  def edit?
    account_owner?
  end

  class Scope < Scope
    def resolve
      @scope.where(user_id: @user.id)
    end
  end

  private

  def account_owner?
    account.owner?(user)
  end
end
