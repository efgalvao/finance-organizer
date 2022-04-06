module AccountsHelper
  def total
    total = 0
    Account.where(user: current_user).includes(:balances).all.each do |account|
      total += account.last_balance.balance
    end
    total
  end
end
