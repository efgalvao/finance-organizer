class CreateNegotiation < ActiveRecord::Migration[6.1]
  def change
    create_table :negotiations do |t|
      t.belongs_to :treasury, null: false, foreign_key: true
      t.integer :kind, default: 0, null: false
      t.datetime :date
      t.monetize :invested, default: 0, null: false, currency: { present: false }
      t.integer :shares, null: false

      t.timestamps
    end
  end
end
