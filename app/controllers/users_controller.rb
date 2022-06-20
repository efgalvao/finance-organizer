class UsersController < ApplicationController
  def overview
    @accounts = policy_scope(Account::Account)
                .where.not(kind: 'card')
                .includes(:stocks, :balances)
                .order(name: :asc)
  end

  def summary
    @user = present current_user
  end
end
