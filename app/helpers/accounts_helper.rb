module AccountsHelper
  def total
    total = 0
    Account.where(user: current_user).includes(:balances).all.each do |account|

      total += account.last_balance.balance
    end
    total
  end

  def free_total
    total = 0
    Account.where(user: current_user).includes(:balances).savings_accounts.each do |account|
      next if account.balances.newest_balance.blank?

      total += account.last_balance.balance
    end
    total
  end

  def locked_total
    total = 0
    Account.where(user: current_user).includes(:balances).stocks_accounts.each do |account|
      next if account.balances.newest_balance.blank?

      total += account.last_balance.balance
    end
    total
  end
end
