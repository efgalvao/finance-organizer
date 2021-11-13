class StockPolicy < ApplicationPolicy
  attr_reader :user, :stock

  def initialize(user, stock)
    super
    @user = user
    @stock = stock
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

  class Scope < Scope
    def resolve
      Stock.includes(:account).where(account: { user_id: @user.id })
    end
  end

  private

  def account_owner?
    stock.account.owner?(user)
  end
end
