class UsersController < ApplicationController
  def overview
    @accounts = policy_scope(Account::Account).includes(:stocks, :balances).order(name: :asc)
  end

  def summary
    @user = current_user
  end
end
