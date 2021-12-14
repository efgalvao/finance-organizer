class UsersController < ApplicationController

  def summary
    @user = current_user
  end

  private

  def users_params
    params.require(:transaction).permit(:title, :account_id, :category_id,
                                        :value, :kind, :date)
  end
end
