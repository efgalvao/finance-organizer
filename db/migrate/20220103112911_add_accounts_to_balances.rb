class AddAccountsToBalances < ActiveRecord::Migration[6.1]
  def change
    add_reference :balances, :account, foreign_key: true
  end
end
