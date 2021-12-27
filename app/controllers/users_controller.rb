class UsersController < ApplicationController
  def overview
    @accounts = policy_scope(Account).includes(:stocks).order('name asc').all
  end

  def summary
    @user = current_user
  end
end
