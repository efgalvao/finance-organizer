class AddDividendsToAccountReports < ActiveRecord::Migration[6.1]
  def change
    add_monetize :account_reports, :dividends, default: 0, currency: { present: false }
  end
end
