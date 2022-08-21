class AddDividendsToUserReports < ActiveRecord::Migration[6.1]
  def change
    add_monetize :user_reports, :dividends, default: 0, currency: { present: false }
  end
end
