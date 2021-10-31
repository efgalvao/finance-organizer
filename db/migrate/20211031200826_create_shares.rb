class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.datetime :aquisition_date
      t.monetize :aquisition_value, default: 0, null: false, currency: { present: false }
      t.belongs_to :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
