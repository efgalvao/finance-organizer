class CreateTransference < ActiveRecord::Migration[6.1]
  def change
    create_table :transferences do |t|
      t.references :sender
      t.references :receiver
      t.references :user, foreign_key: true
      t.date :date
      t.monetize :amount, default: 0, null: false, currency: { present: false }

      t.timestamps
    end
  end
end
