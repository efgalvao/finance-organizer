class UsersController < ApplicationController
  def overview
    @accounts = policy_scope(Account).includes(:stocks).order(name: :asc)
  end

  def summary
    @user = current_user
  end
end
