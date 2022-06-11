class CreateAccountReports < ActiveRecord::Migration[6.1]
  def change
    create_table :account_reports do |t|
      t.datetime :date
      t.monetize :incomes, default: 0, null: false, currency: { present: false }
      t.monetize :expenses, default: 0, null: false, currency: { present: false }
      t.monetize :invested, default: 0, null: false, currency: { present: false }
      t.monetize :final, default: 0, null: false, currency: { present: false }
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
