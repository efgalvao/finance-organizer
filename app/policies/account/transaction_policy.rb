module Account
  class TransactionPolicy < ApplicationPolicy
    attr_reader :user, :transaction

    def initialize(user, transaction)
      super
      @user = user
      @transaction = transaction
    end

    def update?
      owner?
    end

    def edit?
      owner?
    end

    class Scope < Scope
      def resolve
        Transaction.includes(:account).where(account: { user: user })
      end
    end

    private

    def owner?
      transaction.account_user == user
    end
  end
end
