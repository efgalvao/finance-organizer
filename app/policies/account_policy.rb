class AccountPolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, account)
    super
    @user = user
    @account = account
  end

  def show?
    account_owner?
  end

  def edit?
    account_owner?
  end

  def update?
    account_owner?
  end

  def destroy?
    account_owner?
  end

  def month_transactions?
    account_owner?
  end

  def transactions?
    account_owner?
  end

  class Scope < Scope
    def resolve
      @scope.where(user_id: @user.id)
    end
  end

  private

  def account_owner?
    record.owner?(user)
  end
end
