class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean :savings
      t.references :user, foreign_key: { to_table: :users }, null: false
      t.monetize :balance, default: 0, null: false, currency: { present: false }

      t.timestamps
    end
  end
end
