class AddCardExpensesToUserReports < ActiveRecord::Migration[6.1]
  def change
    add_monetize :user_reports, :card_expenses, default: 0, currency: { present: false }
  end
end
