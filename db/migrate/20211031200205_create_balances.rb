class CreateBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :balances do |t|
      t.monetize :balance, default: 0, null: false, currency: { present: false }
      t.datetime :date
      t.references :balanceable, polymorphic: true

      t.timestamps
    end
  end
end
