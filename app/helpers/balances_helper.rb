module BalancesHelper
  def last_balance(account_id)
    # account = Account.find(account_id)

    # account.balances.current.first&.updated_at.nil? ? account.create_balance : account.update_balance

    # account.generate_balance if account.balances.current.first&.updated_at.nil? ||
    #                             account.balances.current.first.updated_at < account.updated_at

    Account.find(account_id).balances.last.balance
  end
end
