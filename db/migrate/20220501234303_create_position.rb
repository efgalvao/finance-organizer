class CreatePosition < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.belongs_to :treasury, null: false, foreign_key: true
      t.datetime :date, null: false
      t.monetize :amount, default: 0, null: false, currency: { present: false }

      t.timestamps
    end
  end
end
