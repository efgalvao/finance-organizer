class AddTotalBalaanceToAccountReports < ActiveRecord::Migration[6.1]
  def change
    add_monetize :account_reports, :total_balance, default: 0, currency: { present: false }
  end
end
