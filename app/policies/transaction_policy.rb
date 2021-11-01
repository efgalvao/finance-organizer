class TransactionPolicy < ApplicationPolicy
  attr_reader :user, :transaction

  def initialize(user, transaction)
    super
    @user = user
    @transaction = transaction
  end

  def index?
    transaction
  end

  def show?
    transaction_user?
  end

  def update?
    transaction_user?
  end

  def edit?
    transaction_user?
  end

  def destroy?
    transaction_user?
  end

  class Scope < Scope
    def resolve
      Account.includes(:transactions).where(user: @user)
    end
  end
end
