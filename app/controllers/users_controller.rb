class UsersController < ApplicationController
  def overview
    @accounts = policy_scope(Account::Account)
                .where.not(kind: 'card')
                .order(name: :asc)
  end

  def summary
    @user = UserPresenter.new(current_user)
  end
end
