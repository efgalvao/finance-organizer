class CreateTreasury < ActiveRecord::Migration[6.1]
  def change
    create_table :treasuries do |t|
      t.string :name, null: false
      t.belongs_to :account, null: false, foreign_key: true
      t.monetize :invested_value, default: 0, null: false, currency: { present: false }
      t.monetize :current_value, default: 0, null: false, currency: { present: false }
      t.integer :shares, null: false, default: 0

      t.timestamps
    end
  end
end
