class AddInvestedToUserReports < ActiveRecord::Migration[6.1]
  def change
    add_monetize :user_reports, :incomes, default: 0, currency: { present: false }
    add_monetize :user_reports, :expenses, default: 0, currency: { present: false }
    add_monetize :user_reports, :invested, default: 0, currency: { present: false }
    add_monetize :user_reports, :final, default: 0, currency: { present: false }
  end
end
