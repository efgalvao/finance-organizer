class CreateUserReports < ActiveRecord::Migration[6.1]
  def change
    create_table :user_reports do |t|
      t.datetime :date
      t.monetize :savings, default: 0, null: false, currency: { present: false }
      t.monetize :stocks, default: 0, null: false, currency: { present: false }
      t.monetize :total, default: 0, null: false, currency: { present: false }
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
